class_name CombatLogic extends Node

##  CombatLogic class handles the flow of combat, manages turn order, resolves attacks,
##  and communicates events through signals. [br]It acts as the primary controller for combat actions,
##  ensuring synchronization between animations and gameplay logic.
##
## This script stores and manages the resolution of units' attacks in combat.[br]
## When a unit attacks, the effect of its attack is "booked" (see [method CombatLogic.book_damage]) for later resolution.[br]
## This process serves two primary purposes:[br]
## 1. Emitting Signals for Pre-Resolution Effects:[br]
##  - - Whenever an attack is booked, a signal is emitted to notify the system of the event.[br]
##  - - This allows other game systems or mechanics (e.g., buffs, debuffs, or triggered abilities) to react to the attack.[br]
##  - - These reactions can modify the attack's properties, such as damage, critical chance, or effects, before the attack is finalized and resolved.[br]
## 2. Synchronizing Attack Resolution with Animations:[br]
##  - - By delaying the execution of the attack until it is resolved, the system ensures that the gameplay logic is in sync with the visual animations.[br]
##  - - This approach creates a cohesive player experience where damage or effects are applied at the precise moment they are visually communicated (e.g., when a sword strikes an enemy or a spell animation finishes).[br]


@onready var main_system := get_parent() as CombatSystem

# The queue of units ready to act, sorted by their initiative.
var attacks_queue: Array[UnitAttack]

# A list of attacks that have been booked but not yet resolved.
var booked_attacks: Array[Attack] = []


var current_attack: UnitAttack

## Tracks the current round of combat.
var current_round := 0


func _ready() -> void:
	EventBus.attack_reached.connect(resolve_closest_attack)

#region Utilities

# Sorts units by their initiative, highest first.
func sorting_by_initiative(a: UnitAttack, b: UnitAttack) -> bool:
	return b.initiative < a.initiative


# Filters out null and dead units from a list.
func filter_nulls(a: Unit) -> bool:
	return a != null and not a.parameters.dead


## Removes duplicate units from an array, maintaining the first occurrence.
func filter_duplicates(arr: Array[Unit]) -> Array[Unit]:
	var result: Array[Unit] = []
	for u in arr:
		if not result.has(u):
			result.append(u)
	return result

#endregion

#region Combat managment

## Sets up the attack queue for the current round and resets atacks for each unit.
func set_queue() -> void:
	# Combine units from both parties, filter out nulls and dead units, then remove duplicates.
	var units: Array[Unit] = main_system.left_party.units.duplicate().filter(filter_nulls) + \
		(main_system.right_party.units.duplicate().filter(filter_nulls))
	units = filter_duplicates(units)
	
	attacks_queue = []
	for unit in units:
		unit.arrange_attacks()
		attacks_queue = attacks_queue + unit.attacks_for_this_round
		#print(unit.attacks_for_this_round)
	
	# Shuffle attacks to randomize attacks with same initiative
	attacks_queue.shuffle()
	attacks_queue.sort_custom(sorting_by_initiative)


## Begins a new combat round, resets the queue, and emits a round-started signal.
func start_round() -> void:
	current_round += 1
	print("Round " + str(current_round))
	set_queue()
	EventBus.round_started.emit()


##  Starts a turn for the next unit in the queue.
func start_turn() -> void:
	var curr := main_system.current_unit
	if curr != null:
		main_system.current_unit = null
		EventBus.turn_ended.emit(curr)
	
	while attacks_queue.size() > 0:
		var attack: UnitAttack = attacks_queue.pop_front()
		if attack == null or attack.unit == null or attack.unit.parameters.dead:
			continue
		main_system.current_unit = attack.unit
		#attack.unit.set_next_attack()
		EventBus.turn_started.emit(main_system.current_unit)
		return


##  Advances the combat flow to the next stage.
##  Starts a new turn or round, or ends the battle if no units are left to act.
func next_stage() -> void:
	start_turn()
	# if start_turn didn't set current_unit, there's no units left in queue
	if main_system.current_unit == null:
		start_round()
		start_turn()
		# if start_turn didn't set current_unit after queue has been reset, there's no units left
		if main_system.current_unit == null:
			end_battle()


##  Initiates the battle by starting the first round and advancing the stage.
func start_battle() -> void:
	start_round()
	next_stage()


##  Ends the battle and cleans up resources.
func end_battle() -> void:
	print("The battle is over!")
#endregion

#region Attack resolution and booking

##  Books an attack for later resolution. This allows effects to modify the attack before it resolves.
##  Emits a signal when an attack is booked, triggering any relevant effects.
func book_damage(attack: Attack, emit: bool = true) -> void:
	booked_attacks.append(attack)
	if emit:
		EventBus.attack_booked.emit(attack)
	
	##  If the attack has an associated effect, instantiate it and apply it to the target.
	if attack.effect == null:
		return
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
	##  Ensure the attack is in the booked list before resolving.
	if not booked_attacks.has(attack):
		return
	booked_attacks.erase(attack)
	attack.resolve()


##  Resolves all booked attacks, clearing the booked list afterward.
func resolve_and_finalize_all_attacks() -> void:
	for attack in booked_attacks:
		const FINALIZE_ATTACK := true
		attack.resolve(FINALIZE_ATTACK)
	booked_attacks.clear()


##  Resolves the first booked attack made by a specific unit.
func resolve_closest_attack(unit: Unit) -> void:
	var attack: Attack = null
	for a in booked_attacks:
		if a.attacker == unit:
			attack = a
			break
	if attack == null:
		#print_debug(unit.unit_name + " doesn't have booked attacks!")
		return
	resolve_attack(attack)
#endregion
