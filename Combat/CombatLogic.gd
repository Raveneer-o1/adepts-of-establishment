class_name CombatLogic extends Node

##  CombatLogic class handles the flow of combat, manages turn order, resolves attacks,
##  and communicates events through signals. It acts as the primary controller for combat actions,
##  ensuring synchronization between animations and gameplay logic.

## This script stores and manages the resolution of units' attacks in combat.
## When a unit attacks, the effect of its attack is "booked" (see the `book_damage()` function) for later resolution.
## This process serves two primary purposes:
## 1. Emitting Signals for Pre-Resolution Effects:
##    - Whenever an attack is booked, a signal is emitted to notify the system of the event.
##    - This allows other game systems or mechanics (e.g., buffs, debuffs, or triggered abilities) to react to the attack.
##    - These reactions can modify the attack's properties, such as damage, critical chance, or effects, before the attack is finalized and resolved.
## 2. Synchronizing Attack Resolution with Animations:
##    - By delaying the execution of the attack until it is resolved, the system ensures that the gameplay logic is in sync with the visual animations.
##    - This approach creates a cohesive player experience where damage or effects are applied at the precise moment they are visually communicated (e.g., when a sword strikes an enemy or a spell animation finishes).


@onready var main_system := get_parent() as CombatSystem

# The queue of units ready to act, sorted by their initiative.
var units_queue: Array[Unit]

# A list of attacks that have been booked but not yet resolved.
var booked_attacks: Array[Attack] = []

# Sorts units by their initiative, highest first.
func sorting_by_initiative(a: Unit, b: Unit) -> bool:
	return b.parameters.initiative < a.parameters.initiative

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

## Sets up the unit queue for the current round.
func set_queue() -> void:
	##  Combine units from both parties, filter out nulls and dead units, then remove duplicates.
	units_queue = main_system.left_party.units.duplicate().filter(filter_nulls) + (
		main_system.right_party.units.duplicate().filter(filter_nulls))
	units_queue = filter_duplicates(units_queue)
	##  Shuffle and sort the queue by initiative.
	units_queue.shuffle()
	units_queue.sort_custom(sorting_by_initiative)

## Tracks the current round of combat.
var current_round := 0

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
	
	while units_queue.size() > 0:
		var unit: Unit = units_queue.pop_at(0)
		if unit == null or unit.parameters.dead:
			continue
		main_system.current_unit = unit
		EventBus.turn_started.emit(main_system.current_unit)
		return

##  Advances the combat flow to the next stage.
##  Starts a new turn or round, or ends the battle if no units are left to act.
func next_stage() -> void:
	start_turn()
	if main_system.current_unit == null:
		start_round()
		start_turn()
		if main_system.current_unit == null:
			end_battle()

##  Initiates the battle by starting the first round and advancing the stage.
func start_battle() -> void:
	start_round()
	next_stage()

##  Ends the battle and cleans up resources.
func end_battle() -> void:
	print("The battle is over!")

##  Books an attack for later resolution. This allows effects to modify the attack before it resolves.
##  Emits a signal when an attack is booked, triggering any relevant effects.
func book_damage(attack: Attack, emit: bool = true) -> void:
	booked_attacks.append(attack)
	if emit:
		EventBus.attack_booked.emit(attack)
	
	##  If the attack has an associated effect, instantiate it and apply it to the target.
	if attack.effect == null:
		return
	var effect_object := attack.effect.instantiate() as TemporaryEffect
	attack.target.add_child(effect_object)

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
	attack.target.resolve_attack(attack)

##  Resolves all booked attacks, clearing the booked list afterward.
func resolve_all_attacks() -> void:
	for a in booked_attacks:
		a.target.resolve_attack(a)
	booked_attacks.clear()

##  Resolves the first booked attack made by a specific unit.
func resolve_closest_attack(unit: Unit) -> void:
	var attack: Attack = null
	for a in booked_attacks:
		if a.attacker == unit:
			attack = a
			break
	if attack == null:
		print_debug(unit.unit_name + " doesn't have booked attacks!")
		return
	resolve_attack(attack)

##  Sets up event connections when the node is ready.
func _ready() -> void:
	EventBus.attack_reached.connect(resolve_closest_attack)
