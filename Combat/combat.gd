class_name CombatSystem
extends Node2D

## Handles high-level interactions between combat system nodes, external systems, 
## and utility functions such as player input

## References to child nodes for managing parties and combat logic
@onready var left_party: Party = get_node("LeftParty")
@onready var right_party: Party = get_node("RightParty")
@onready var combat_logic: CombatLogic = get_node("CombatLogic")
@onready var active_unit_marker := get_node("ActiveUnitMarker") as AnimatedSprite2D

## Configuration variables for parties
@export var left_party_units: Array[String]
@export var right_party_units: Array[String]

## Temporary label scene for displaying text near units
const TEMP_LABEL = preload("res://Combat/TempLabel.tscn")
const DISTANCE_TO_LABEL = 15.0

## Loaded unit resources and highlighted units
var loaded_units: Dictionary = {}
var highlighted_units: Array[Unit] = []

## Reference to the current active unit in combat
var _current_unit: Unit
var current_unit: Unit:
	get:
		return _current_unit
	set(value):
		_current_unit = value
		if value == null or value.parameters.dead:
			active_unit_marker.visible = false
		else:
			active_unit_marker.position = value.global_position
			active_unit_marker.visible = true

## Handles the resolution of all attacks and prepares for the next combat stage
func finish_attack() -> void:
	combat_logic.resolve_all_attacks()
	for unit in highlighted_units:
		if unit != null:
			unit.reset_highlight()
	highlighted_units.clear()
	combat_logic.next_stage()

## Called when an attack is finished
## Checks if the attack was of an active unit and triggers attack resolution if it is
func check_finished_animation(unit: Unit) -> void:
	if unit == current_unit:
		finish_attack()

## Processes a click event on a unit
func clicked_unit(unit: Unit) -> void:
	var target_added = current_unit.give_target(unit)
	if not target_added:
		print("Unable to attack this target")
		return
	unit.highlight_externally()
	highlighted_units.append(unit)

## Displays text near a unit
func display_text_near_unit(unit: Unit, text: String) -> void:
	var offset = Vector2(randf() - 0.5, randf() - 0.5).normalized() * DISTANCE_TO_LABEL
	var lbl: Label = TEMP_LABEL.instantiate()
	unit.add_child(lbl)
	lbl.text = text
	lbl.set_begin(unit.global_position + offset)

#region Initialization
func load_unit_list(list: Array[String]) -> void:
	for path in list:
		if not path.is_empty() and not loaded_units.has(path):
			var resource = load(path)
			if resource != null:
				loaded_units[path] = resource
			else:
				print_debug("Resource not found: " + path)

func load_units() -> void:
	load_unit_list(left_party_units)
	load_unit_list(right_party_units)

func initialize_variables() -> void:
	left_party.main_system = self
	right_party.main_system = self
	left_party.other_party = right_party
	right_party.other_party = left_party
	
	left_party.initialize_variables()
	right_party.initialize_variables()
	EventBus.connect("attack_animation_finished", Callable(self, "check_finished_animation"))

func place_units() -> void:
	right_party.place_units(right_party_units)
	left_party.place_units(left_party_units)

func _ready() -> void:
	initialize_variables()
	load_units()
	place_units()
	combat_logic.start_battle()
#endregion
