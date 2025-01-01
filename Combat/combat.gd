class_name CombatSystem extends Node2D

@onready var left_party: Party = get_node("LeftParty")
@onready var right_party: Party = get_node("RightParty")

@export var left_party_units: Array[String]
@export var right_party_units: Array[String]

const TEMP_LABEL = preload("res://Combat/TempLabel.tscn")
const DISTANCE_TO_LABEL = 15.0

var loaded_units: Dictionary = {}

var _current_unit: Unit
var current_unit: Unit:
	get:
		return _current_unit
	set(value):
		_current_unit = value
		if value == null:
			active_unit_marker.visible = false
		else:
			if value.parameters.dead:
				active_unit_marker.visible = false
			else:
				active_unit_marker.position = value.global_position
				active_unit_marker.visible = true

var units_queue: Array[Unit]

@onready var active_unit_marker := get_node("ActiveUnitMarker") as AnimatedSprite2D

var booked_attacks: Array[Attack] = []

func finish_attack() -> void:
	resolve_all_attacks()
	next_stage()

func check_finished_animation(unit: Unit) -> void:
	if unit == current_unit:
		finish_attack()

func book_damage(attack: Attack) -> void:
	booked_attacks.append(attack)
	EventBus.attack_booked.emit(attack)

func resolve_attack(attack: Attack) -> void:
	if not booked_attacks.has(attack):
		return
	booked_attacks.erase(attack)
	attack.target.resolve_attack(attack)

func resolve_all_attacks() -> void:
	for a in booked_attacks:
		a.target.resolve_attack(a)
	booked_attacks.clear()

func clicked_unit(unit: Unit) -> void:
	var target_added = current_unit.give_target(unit)
	if not target_added:
		print("Unable to attack this target")

func display_text_near_unit(unit: Unit, text: String) -> void:
	var pos = Vector2(randf() - 0.5, randf() - 0.5).normalized() * DISTANCE_TO_LABEL
	
	var lbl: Label = TEMP_LABEL.instantiate()
	unit.add_child(lbl)
	lbl.text = text
	lbl.position = unit.global_position + pos
	#print(lbl.position)

func sorting_by_initiative(a: Unit, b: Unit) -> bool:
	return b.parameters.initiative > a.parameters.initiative

func filter_nulls(a: Unit) -> bool:
	return a != null

func set_queue() -> void:
	units_queue = left_party.units.duplicate().filter(filter_nulls) + right_party.units.duplicate().filter(filter_nulls)
	units_queue.shuffle()
	units_queue.sort_custom(sorting_by_initiative)

func start_round() -> void:
	set_queue()
	EventBus.round_started.emit()

func start_turn() -> void:
	EventBus.turn_ended.emit(current_unit)
	if units_queue.size() > 0:
		current_unit = units_queue.pop_at(0)
		EventBus.turn_started.emit(current_unit)

func next_stage() -> void:
	if units_queue.size() > 0:
		start_turn()
	else:
		start_round()
		start_turn()

#region Initialization

func load_units() -> void:
	for s in left_party_units:
		if loaded_units.has(s):
			continue
		var l := load(s)
		if l == null:
			print_debug("Not found: " + s)
		else:
			loaded_units[s] = l
	for s in right_party_units:
		if loaded_units.has(s):
			continue
		var l := load(s)
		if l == null:
			print_debug("Not found: " + s)
		else:
			loaded_units[s] = l

func initialize_variables() -> void:
	left_party.main_system = self
	left_party.other_party = right_party
	right_party.main_system = self
	right_party.other_party = left_party
	
	left_party.initialize_variables()
	right_party.initialize_variables()
	
	#var c = Callable(self, "check_finished_animation")
	EventBus.connect("attack_animation_finished", check_finished_animation)
	#print(EventBus.attack_animation_finished.get_connections())

func place_units() -> void:
	right_party.place_units(right_party_units)
	left_party.place_units(left_party_units)

func _ready() -> void:
	initialize_variables()
	load_units()
	place_units()
	next_stage()
#endregion
