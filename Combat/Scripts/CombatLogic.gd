class_name CombatLogic extends Node

## The main brain of a combat system.
##
## [CombatLogic] manages the actual combat flow: it tells if a specific action is allowed,
## and manages combat-related values.

@onready var main_system := get_parent() as CombatSystem

## The queue of units ready to act, sorted by their initiative.
var attacks_queue: Array[UnitAttack]

## A list of attacks that have been booked but not yet resolved.
var booked_attacks: Array[Attack] = []

## A list of all attacks that were shifted via "Wait" option
var waited_attacks: Array[UnitAttack] = []

var current_attack: UnitAttack

## Tracks the current round of combat.
var current_round := 0

var battle_in_progress: bool = true

func _ready() -> void:
	EventBus.attack_reached.connect(resolve_closest_attack)
	EventBus.unit_died.connect(check_dead_unit)

#region Utilities

func sorting_by_initiative(a: UnitAttack, b: UnitAttack) -> bool:
	return b.initiative < a.initiative

func filter_nulls(a: Unit) -> bool:
	return a != null and not a.parameters.dead

func filter_duplicates(arr: Array[Unit]) -> Array[Unit]:
	var result: Array[Unit] = []
	for u in arr:
		if not result.has(u):
			result.append(u)
	return result

#endregion

#region Combat managment

func remove_attack_from_queue(attack: UnitAttack) -> void:
	if not attacks_queue.has(attack):
		return
	
	main_system.remove_miniature(attack)
	
	attacks_queue.erase(attack)

## Sets up the attack queue for the current round and resets atacks for each unit.
func set_queue() -> void:
	# Combine units from both parties, filter out nulls and dead units, then remove duplicates.
	var left_units: Array[Unit] = main_system.left_party.units.filter(filter_nulls)
	var right_units: Array[Unit] = main_system.right_party.units.filter(filter_nulls)
	var units: Array[Unit] = left_units + right_units
	units = filter_duplicates(units)
	
	attacks_queue = []
	for unit in units:
		unit.arrange_attacks()
		attacks_queue.append_array(unit.attacks_for_this_round)
	
	# Shuffle attacks to randomize attacks with same initiative
	attacks_queue.shuffle()
	attacks_queue.sort_custom(sorting_by_initiative)
	
	main_system.fill_miniatures_queue()


func check_dead_unit(unit: Unit) -> void:
	if not unit.parameters.dead: return
	var attacks_to_remove: Array[UnitAttack] = []
	
	# Iterate through attacks_queue instead of unit.attacks_for_this_round for robustness:
	# attacks_for_this_round could theoretically be out of sync with attacks_queue
	# (e.g., when adding a new attack to the unit)
	for attack in attacks_queue:
		if attack != null and \
				attack.unit == unit:
			attacks_to_remove.append(attack)
	
	for attack in attacks_to_remove:
		remove_attack_from_queue(attack)
	
	if unit == main_system.current_unit:
		next_stage()


## Attempts waiting. If succsesfull, shifts current attack of a current unit to the end of a queue
func try_wait() -> bool:
	if waited_attacks.has(current_attack):
		return false
	if main_system.current_unit.try_waiting():
		waited_attacks.append(current_attack)
		attacks_queue.append(current_attack)
		return true
	return false


## Begins a new combat round, resets the queue, and emits a [signal round_started]
func start_round() -> void:
	if not battle_in_progress:
		return
	waited_attacks.clear()
	current_round += 1
	print("Round " + str(current_round))
	set_queue()
	EventBus.round_started.emit()


## Starts a turn for the next unit in the queue.
func start_turn(remove_miniature: bool = true) -> void:
	if not battle_in_progress:
		return
	
	var curr := main_system.current_unit
	
	if curr != null:
		main_system.current_unit = null
		if remove_miniature:
			main_system.remove_miniature(current_attack)
		EventBus.turn_ended.emit(curr)
	
	current_attack = null
	
	# trying to assign current_attack while the queue in not empty
	while attacks_queue.size() > 0:
		# Skipping all dead references and dead units
		# If we skip all entries,
		# method will return without setting current_unit which means no unit was found
		if not is_instance_valid(attacks_queue.front()):
			attacks_queue.remove_at(0)
			continue
		current_attack = attacks_queue.pop_front()
		if current_attack == null or \
				not current_attack.can_be_performed():
			continue
		
		assert(current_attack.unit != null, "unit field of a current_attack is empty!")
		EventBus.turn_started.emit(current_attack.unit)
		
		if current_attack.unit.parameters.dead:
			continue
		
		main_system.current_unit = current_attack.unit
		if main_system.current_unit.skipping_turn:
			return
		
		main_system.display_hints()
		main_system.current_player.start_turn()
		return



## Advances the combat flow to the next stage.
## Starts a new turn or round, or ends the battle if no units are left to act.
func next_stage(remove_miniature: bool = true) -> void:
	if not battle_in_progress:
		return
	
	main_system.check_winner()
	if not battle_in_progress:
		return
	
	start_turn(remove_miniature)
	# if start_turn didn't set current_unit, there's no units left in queue
	if main_system.current_unit == null:
		start_round()
		start_turn(remove_miniature)
		
		# if start_turn didn't set current_unit after queue has been reset,
		# there's no units left
		if main_system.current_unit == null:
			end_battle()

func start_battle() -> void:
	initialize_effects()
	start_round()
	next_stage()

func initialize_effects() -> void:
	for unit in main_system.left_party.units + main_system.right_party.units:
		if unit != null:
			unit.parameters.initialize_effects()

func end_battle() -> void:
	if not battle_in_progress:
		return
	print("The battle is over!")
	main_system.win_label.visible = true
	battle_in_progress = false


#endregion

#region Attack resolution and booking

## Checks if the attack needs to be redirected due to shielding and changes it accordingly
func check_shielding(attack: Attack) -> void:
	if not attack: return
	if &"shot" not in attack.tags:
		return
	for target: Unit in attack.targets:
		if not target: continue
		if target.parameters.large_unit: continue
		var pos: int = target.party_position
		if pos % 2 == 0: continue  # only backline can be shielded
		var potential_shields: Array[Unit] = \
			target.party.get_units_at_positions( [pos+1, pos-1], false )
		for s in potential_shields:
			s.attempt_shielding(attack, target)

## Books an attack for later resolution. This allows effects to modify the attack before it resolves.
## Emits a signal when an attack is booked, triggering any relevant effects.
func book_damage(attack: Attack, emit: bool = true) -> void:
	booked_attacks.append(attack)
	check_shielding(attack)
	
	if emit:
		EventBus.attack_booked.emit(attack)
	
	if attack.effect == null:
		return
	
	# If the attack has an associated effect, instantiate it and apply it to the target.
	for target in attack.targets:
		var effect_object := attack.effect.instantiate() as TemporaryEffect
		target.add_child(effect_object)


##  Books an array of attacks, emitting a signal only for the first one.
func book_damages(attacks: Array[Attack]) -> void:
	if attacks.size() == 0:
		return
	EventBus.attack_booked.emit(attacks[0])
	for a in attacks:
		book_damage(a, false)


##  Resolves a specific booked attack and applies its effects to the target.
func resolve_attack(attack: Attack) -> void:
	if not booked_attacks.has(attack):
		return
	booked_attacks.erase(attack)
	attack.resolve()


##  Resolves all booked attacks, clearing the booked list afterward.
func resolve_and_finalize_all_attacks() -> void:
	for attack in booked_attacks:
		const FINALIZE_ATTACK := true
		attack.resolve(FINALIZE_ATTACK)
	
	# if some units have taking_damage_attacks queued, finilize that as well
	for unit in main_system.left_party.units + main_system.right_party.units:
		if is_instance_valid(unit) and unit:
			unit.update_visuals()
	
	booked_attacks.clear()


##  Resolves the first booked attack made by a specific unit.
func resolve_closest_attack(unit: Unit) -> void:
	var attack: Attack = null
	for a in booked_attacks:
		if a.attacker == unit:
			attack = a
			break
	if attack == null:
		return
	resolve_attack(attack)
#endregion
