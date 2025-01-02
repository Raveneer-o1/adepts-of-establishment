class_name CombatLogic extends Node

## CombatLogic class handles combat flow and executes actions with units and parties,
## including turn order, attack resolution, and event communication.
##
## This scripts stores and manages resolution of units' attacks.
## When a unit attacks, the effect of it's attack is booked *see book_damage()* to be resolved later.
## This serves two main purposes:
##  1. Whenever the attack is stored, a signal is emitted
##   so any relevant effect can be triggered on said attack, changing it if need be
##  2. Storing attack delays execution to sync dealing damage with animations.

@onready var main_system := get_parent() as CombatSystem

var units_queue: Array[Unit]
var booked_attacks: Array[Attack] = []


func sorting_by_initiative(a: Unit, b: Unit) -> bool:
	return b.parameters.initiative < a.parameters.initiative

func filter_nulls(a: Unit) -> bool:
	return a != null and not a.parameters.dead

func filter_duplicates(arr: Array[Unit]) -> Array[Unit]:
	var result: Array[Unit] = []
	for u in arr:
		if not result.has(u):
			result.append(u)
	return result

func set_queue() -> void:
	units_queue = main_system.left_party.units.duplicate().filter(filter_nulls) + (
			main_system.right_party.units.duplicate().filter(filter_nulls))
	units_queue = filter_duplicates(units_queue)
	units_queue.shuffle()
	units_queue.sort_custom(sorting_by_initiative)

var current_round := 0

func start_round() -> void:
	current_round += 1
	print("Round " + str(current_round))
	set_queue()
	EventBus.round_started.emit()

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

func next_stage() -> void:
	start_turn()
	if main_system.current_unit == null:
		start_round()
		start_turn()
		if main_system.current_unit == null:
			end_battle()

func start_battle() -> void:
	start_round()
	next_stage()

func end_battle() -> void:
	print("The battle is over!")

## Booked damage is dealt when resolve_attack(), resolve_closest_attack() or resolve_all_attacks()
## is called. before that other effects can impact the specific values of an attack.
## NOTE: attack here already comes with determined value "whiff" that represents whether it's missed of not
func book_damage(attack: Attack) -> void:
	booked_attacks.append(attack)
	EventBus.attack_booked.emit(attack)

func resolve_attack(attack: Attack) -> void:
	
	# NOTE: this check is currently redundant, because we do the same check outside every time we call this function
	if not booked_attacks.has(attack):
		return
	
	booked_attacks.erase(attack)
	attack.target.resolve_attack(attack)

func resolve_all_attacks() -> void:
	for a in booked_attacks:
		a.target.resolve_attack(a)
	booked_attacks.clear()

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

func  _ready() -> void:
	EventBus.attack_reached.connect(resolve_closest_attack)
