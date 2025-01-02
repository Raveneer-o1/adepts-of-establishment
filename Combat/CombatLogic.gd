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
	return b.parameters.initiative > a.parameters.initiative

func filter_nulls(a: Unit) -> bool:
	return a != null

func set_queue() -> void:
	units_queue = main_system.left_party.units.duplicate().filter(filter_nulls) + (
			main_system.right_party.units.duplicate().filter(filter_nulls))
	units_queue.shuffle()
	units_queue.sort_custom(sorting_by_initiative)

func start_round() -> void:
	set_queue()
	EventBus.round_started.emit()

func start_turn() -> void:	
	EventBus.turn_ended.emit(main_system.current_unit)
	main_system.current_unit = null
	while units_queue.size() > 0:
		var unit: Unit = units_queue.pop_at(0)
		if unit == null or unit.parameters.dead:
			continue
		main_system.current_unit = unit
		EventBus.turn_started.emit(main_system.current_unit)

func next_stage() -> void:
	start_turn()
	if main_system.current_unit == null:
		start_round()
		start_turn()
		if main_system.current_unit == null:
			end_battle()

func end_battle() -> void:
	pass

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
