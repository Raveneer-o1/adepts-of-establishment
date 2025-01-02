class_name CombatSystem
extends Node2D

## The CombatSystem class hanles high-level interactions between internal nodes and external systems
## and utility functions such as player input



@onready var left_party: Party = get_node("LeftParty")
@onready var right_party: Party = get_node("RightParty")

@export var left_party_units: Array[String]
@export var right_party_units: Array[String]

@onready var combat_logic: CombatLogic = get_node("CombatLogic")

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


@onready var active_unit_marker := get_node("ActiveUnitMarker") as AnimatedSprite2D

var highlighted_units: Array[Unit] = []

func finish_attack() -> void:
	combat_logic.resolve_all_attacks()
	combat_logic.next_stage()
	for u in highlighted_units:
		if u != null:
			u.reset_highlight()
	highlighted_units.clear()

func check_finished_animation(unit: Unit) -> void:
	if unit == current_unit:
		finish_attack()

func clicked_unit(unit: Unit) -> void:
	var target_added = current_unit.give_target(unit)
	if not target_added:
		print("Unable to attack this target")
		return
	unit.highlight_externally()
	highlighted_units.append(unit)

func display_text_near_unit(unit: Unit, text: String) -> void:
	var pos = Vector2(randf() - 0.5, randf() - 0.5).normalized() * DISTANCE_TO_LABEL
	
	var lbl: Label = TEMP_LABEL.instantiate()
	unit.add_child(lbl)
	lbl.text = text
	lbl.position = unit.global_position + pos
	#print(lbl.position)

#region Initialization

func load_unit_list(list: Array[String]) -> void:
	for s in list:
		if loaded_units.has(s):
			continue
		if s.is_empty():
			continue
		var l := load(s)
		if l == null:
			print_debug("Not found: " + s)
		else:
			loaded_units[s] = l

func load_units() -> void:
	load_unit_list(left_party_units)
	load_unit_list(right_party_units)

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
	combat_logic.start_battle()
#endregion
