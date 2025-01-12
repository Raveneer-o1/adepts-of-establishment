class_name CombatSystem
extends Node2D

## Handles high-level interactions between combat system nodes, external systems, 
## and utility functions such as player input.

# Temporary label scene for displaying text near units
const TEMP_LABEL = preload("res://Combat/TempLabel.tscn")
const DISTANCE_TO_LABEL = 55.0
const UNIT_SPOT = preload("res://Combat/unit_spot.tscn")

const SHOW_HINTS_NEVER = 0
const SHOW_HINTS_ALWAYS = 1
const SHOW_HINTS_ON_HOVER = 2
## Number of states show_hitns_mode can have
const SHOW_HINTS_MAX = 3

const WIN_LABEL_LINE = "[center][color=green]%s[/color][/center]"
const TIME_TO_END = 2.5

# Configuration variables for parties
@export var left_party_units: Array[String]
@export var right_party_units: Array[String]

@export var unit_parameters_database: Resource

@export var unit_marker: Resource

## Loaded unit resources and highlighted units
var loaded_units: Dictionary = {}
var highlighted_units: Array[UnitSpot] = []

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

var show_hitns_mode: int = SHOW_HINTS_ON_HOVER

var displayed_hints : Array[AnimatedSprite2D] = []

var timer: SceneTreeTimer

# References to child nodes for managing parties and combat logic
@onready var left_party: Party = get_node("LeftParty")
@onready var right_party: Party = get_node("RightParty")
@onready var combat_logic: CombatLogic = get_node("CombatLogic")
@onready var active_unit_marker := get_node("ActiveUnitMarker") as AnimatedSprite2D
@onready var win_label: RichTextLabel = $"Win Label"


## Checks if any party is empty and determines a winner
func check_winner(_unit: Unit) -> void:
	if timer != null:
		return
	var left_empty = left_party.check_if_empty()
	var right_empty = right_party.check_if_empty()
	if left_empty and right_empty:
		win_label.text = WIN_LABEL_LINE % "Tie!"
		combat_logic.end_battle()
		start_end_countdown()
		return
	if left_empty:
		win_label.text = WIN_LABEL_LINE % "Right wins!"
		combat_logic.end_battle()
		start_end_countdown()
		return
	if right_empty:
		win_label.text = WIN_LABEL_LINE % "Left wins!"
		combat_logic.end_battle()
		start_end_countdown()
		return

## Handles the resolution of all attacks and prepares for the next combat stage
func finish_attack() -> void:
	combat_logic.resolve_and_finalize_all_attacks()
	for spot in highlighted_units:
		if spot != null:
			spot.reset_highlight()
	highlighted_units.clear()
	combat_logic.next_stage()

## Called when an attack is finished
## Checks if the attack was of an active unit and triggers attack resolution if it is
func check_finished_animation(unit: Unit) -> void:
	if unit == current_unit:
		finish_attack()

## Processes a click event on a unit
func clicked_unit(spot: UnitSpot) -> void:
	if not combat_logic.battle_in_progress:
		return
	var target_added = current_unit.give_target(spot)
	if not target_added:
		print("Unable to attack this target")
		return
	if spot != null:
		spot.highlight_externally()
		highlighted_units.append(spot)


#region UI utilities

## Clears all hints to prepare for the next state
func remove_hints() -> void:
	for hint in displayed_hints:
		hint.queue_free()
	displayed_hints.clear()
	for spot in left_party.unit_spots + right_party.unit_spots:
		if spot == null:
			continue
		spot.get_node("Area2D/HighlightAnimation").modulate = Color.WHITE

## Shows hints according to the value of [member CombatSystem.show_hitns_mode]
func display_hints() -> void:
	remove_hints()
	match show_hitns_mode:
		SHOW_HINTS_ALWAYS:
			for unit in left_party.units + right_party.units:
				if unit == null or unit.parameters.dead:
					continue
				if combat_logic.current_attack.target_validation.call(current_unit, unit.spot):
					var marker: AnimatedSprite2D = unit_marker.instantiate()
					displayed_hints.append(marker)
					unit.add_child(marker)
					marker.modulate = Color.FOREST_GREEN
		SHOW_HINTS_ON_HOVER:
			for spot in left_party.unit_spots + right_party.unit_spots:
				if spot == null or spot.unit == null or spot.unit.parameters.dead:
					continue
				var color: Color = Color.FIREBRICK
				if combat_logic.current_attack.target_validation.call(current_unit, spot):
					color = Color.FOREST_GREEN
				spot.area_2d.get_node("HighlightAnimation").modulate = color

## Displays a vanishing message
func display_text_near_unit(unit: Unit, text: String) -> void:
	var x_offset := randf() - 0.5
	var y_offset := randf_range(-abs(x_offset), 0.0)
	var offset = Vector2(x_offset, y_offset).normalized() * DISTANCE_TO_LABEL
	#print_debug(offset)
	var lbl: Label = TEMP_LABEL.instantiate()
	unit.add_child(lbl)
	lbl.text = text
	lbl.set_begin(unit.global_position + offset)

#endregion

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
	EventBus.turn_started.connect(check_winner)
	EventBus.unit_died.connect(check_winner)
	left_party_units = EventBus.left_units
	right_party_units = EventBus.right_units
	

func place_units() -> void:
	right_party.place_units(right_party_units)
	left_party.place_units(left_party_units)

func _ready() -> void:
	initialize_variables()
	load_units()
	place_units()
	combat_logic.start_battle()
#endregion

#region Unilities


## Loads menu scene as current one. If [member EventBus.packed_menu] is empty,
## loads new scene from [code]"res://Menu/Scenes/menu.tscn"[/code]
func end_scene() -> void:
	if EventBus.packed_menu == null:
		get_tree().change_scene_to_file("res://Menu/Scenes/menu.tscn")
	else:
		get_tree().change_scene_to_packed(EventBus.packed_menu)


## Starts a timer for [member CombatSystem.TIME_TO_END] seconds.
## On timeout loads menu scene.
func start_end_countdown() -> void:
	if timer != null:
		return
	timer = get_tree().create_timer(TIME_TO_END)
	timer.timeout.connect(end_scene)

#endregion


func _on_button_defense_pressed() -> void:
	if current_unit.try_take_defense_stance():
		combat_logic.next_stage()


func _on_button_wait_pressed() -> void:
	combat_logic.try_wait()


func _on_target_hunts_button_pressed() -> void:
	show_hitns_mode = (show_hitns_mode + 1) % SHOW_HINTS_MAX
	var new_text: String
	match show_hitns_mode:
		SHOW_HINTS_NEVER:
			new_text = "Never"
		SHOW_HINTS_ALWAYS:
			new_text = "Always"
		SHOW_HINTS_ON_HOVER:
			new_text = "Auto"
	$"../UI/ParentContainer/PanelContainer/HBoxContainer/TargetHintsContainer/TargetHuntsButton".text = new_text
	display_hints()


func _on_button_start_attack_pressed() -> void:
	current_unit.start_attacking()
