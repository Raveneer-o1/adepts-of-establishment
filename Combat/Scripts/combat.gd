class_name CombatSystem
extends Node2D

## Handles high-level interactions between combat system nodes, external systems, 
## and utility functions such as player input.

# Temporary label scene for displaying text near units
const TEMP_LABEL = preload("res://Combat/Scenes/TempLabel.tscn")
const _DISTANCE_TO_LABEL = 45.0
const SQRT_2 = sqrt(2.0)
const UNIT_SPOT = preload("res://Combat/Scenes/unit_spot.tscn")

const UNIT_MINIATURE = preload("res://Combat/Scenes/unit_in_queue.tscn")

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

@export var left_player: PlayerAPI
@export var right_player: PlayerAPI


## Offsets for a label placement. If you use random positioning, labels are
## too often very close to each other and become unreadable
var label_positions : Array[Vector2] = [
	Vector2(0.0, _DISTANCE_TO_LABEL),
	Vector2(0.0, -_DISTANCE_TO_LABEL),
	Vector2(_DISTANCE_TO_LABEL, 0.0),
	Vector2(-_DISTANCE_TO_LABEL, 0.0),
	Vector2(_DISTANCE_TO_LABEL / SQRT_2, _DISTANCE_TO_LABEL / SQRT_2),
	Vector2(_DISTANCE_TO_LABEL / SQRT_2, - _DISTANCE_TO_LABEL / SQRT_2),
	Vector2(- _DISTANCE_TO_LABEL / SQRT_2, _DISTANCE_TO_LABEL / SQRT_2),
	Vector2(- _DISTANCE_TO_LABEL / SQRT_2, - _DISTANCE_TO_LABEL / SQRT_2),
]

var label_positions_length: int = label_positions.size()
var current_label_position: int = 0

var label_position: Vector2:
	get:
		current_label_position += 1
		current_label_position = current_label_position % label_positions_length
		return label_positions[current_label_position]

## Loaded unit resources and highlighted units
var loaded_units: Dictionary = {}
var highlighted_units: Array[UnitSpot] = []

## Reference to the current active unit in combat
var _current_unit: Unit
var current_unit: Unit:
	get:
		return _current_unit
	set(value):
		current_player = null
		_current_unit = value
		if value == null or value.parameters.dead:
			active_unit_marker.visible = false
		else:
			active_unit_marker.position = value.global_position
			active_unit_marker.visible = true
			current_player = value.party.player

var _current_player: PlayerAPI
var current_player: PlayerAPI:
	get:
		return _current_player
	set(value):
		if _current_player != null:
			_current_player.disabled = true
		
		_current_player = value
		
		if value != null:
			value.disabled = false


var show_hitns_mode: int = SHOW_HINTS_ON_HOVER

var displayed_hints : Array[AnimatedSprite2D] = []

var timer: SceneTreeTimer

# References to child nodes for managing parties and combat logic
@onready var left_party: Party = get_node("LeftParty")
@onready var right_party: Party = get_node("RightParty")
@onready var combat_logic: CombatLogic = get_node("CombatLogic")
@onready var active_unit_marker := get_node("ActiveUnitMarker") as AnimatedSprite2D
@onready var win_label: RichTextLabel = $"Win Label"
@onready var queue_for_unit_miniatures: HBoxContainer = \
		$"../UI/ParentContainer/PanelContainer/HBoxContainer/Queue"


## Checks if any party is empty and determines a winner
func check_winner(_unit: Unit) -> void:
	if timer != null:
		return
	var left_empty := left_party.check_if_empty()
	var right_empty := right_party.check_if_empty()
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
func choose_unit(spot: UnitSpot) -> void:
	if not combat_logic.battle_in_progress:
		return
	if current_player == null:
		return
	
	var target_added := current_unit.give_target(spot)
	if not target_added:
		print("Unable to attack this target")
		return
	if spot != null:
		spot.highlight_externally()
		highlighted_units.append(spot)


func try_waiting() -> bool:
	if combat_logic.try_wait():
		combat_logic.next_stage()
		return true
	return false


func try_taking_defense_stance() -> bool:
	if current_unit.try_take_defense_stance():
		combat_logic.next_stage()
		return true
	return false


func start_attacking_chosen_targets() -> void:
	current_unit.start_attacking()

#region UI utilities

func clear_nearest_miniature() -> void:
	if queue_for_unit_miniatures.get_child_count() > 0:
		(queue_for_unit_miniatures.get_child(0).get_child(0) as UnitInQueue).animate_exit()

func fill_miniatures_queue() -> void:
	for miniature in queue_for_unit_miniatures.get_children():
		miniature.queue_free()
	
	for attack in combat_logic.attacks_queue:
		var new_miniature := UNIT_MINIATURE.instantiate()
		new_miniature.get_child(0).unit = attack.unit
		queue_for_unit_miniatures.add_child(new_miniature)

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
			var avaliable_targets := find_avaliable_targets()
			for unit in left_party.units + right_party.units:
				if unit == null or unit.parameters.dead:
					continue
				if avaliable_targets.has(unit.spot):
					var marker: AnimatedSprite2D = unit_marker.instantiate()
					displayed_hints.append(marker)
					unit.add_child(marker)
					marker.modulate = Color.FOREST_GREEN
		SHOW_HINTS_ON_HOVER:
			var avaliable_targets := find_avaliable_targets()
			for spot in left_party.unit_spots + right_party.unit_spots:
				if spot == null or spot.unit == null or spot.unit.parameters.dead:
					continue
				var color: Color = Color.FIREBRICK
				if avaliable_targets.has(spot):
					color = Color.FOREST_GREEN
				spot.area_2d.get_node("HighlightAnimation").modulate = color


## Adds a vanishing message near a unit and starts the display process
func display_text_near_unit(unit: Unit, text: String, color: Color = Color.WHITE) -> void:
	unit.display_text_near_unit(text, color)


#endregion

#region Initialization
func load_unit_list(list: Array[String]) -> void:
	for path in list:
		if not path.is_empty() and not loaded_units.has(path):
			var resource := load(path)
			if resource != null:
				loaded_units[path] = resource
			else:
				print_debug("Resource not found: " + path)

func load_units() -> void:
	load_unit_list(left_party_units)
	load_unit_list(right_party_units)

func check_refs_validity() -> bool:
	var are_refs_valid: bool = true
	
	if (not is_instance_valid(left_party)) or left_party == null:
		print_debug("Left party is not found!")
		are_refs_valid = false
	
	if (not is_instance_valid(right_party)) or right_party == null:
		print_debug("Right party is not found!")
		are_refs_valid = false
	
	if (not is_instance_valid(left_player)) or left_player == null:
		print_debug("Left player is not found!")
		are_refs_valid = false
	
	if (not is_instance_valid(right_player)) or right_player == null:
		print_debug("Right player is not found!")
		are_refs_valid = false
	
	
	return are_refs_valid

func initialize_variables() -> void:
	if not check_refs_validity():
		end_scene()
		return
	
	# randomize positions of temporary labels
	label_positions.shuffle()
	
	left_party.main_system = self
	left_party.other_party = right_party
	left_party.player = left_player
	
	right_party.main_system = self
	right_party.other_party = left_party
	right_party.player = right_player
	
	left_player.combat_system = self
	left_player.party = left_party
	if EventBus.left_controller != null:
		left_player.add_child(EventBus.left_controller.instantiate())
	
	right_player.combat_system = self
	right_player.party = right_party
	if EventBus.right_controller != null:
		right_player.add_child(EventBus.right_controller.instantiate())
	
	left_party.initialize_variables()
	right_party.initialize_variables()
	EventBus.attack_animation_finished.connect(check_finished_animation)
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

func find_targets_for_attack(attack: UnitAttack) -> Array[UnitSpot]:
	if attack == null:
		return []
	
	var result: Array[UnitSpot] = []
	var all_unit_spots: Array[UnitSpot] = left_party.unit_spots + right_party.unit_spots
	
	for spot in all_unit_spots:
		if spot == null:
			continue
		if attack.target_validation._validate_target(attack.unit, spot):
			result.append(spot)
	
	return result

func find_avaliable_targets(unit: Unit = current_unit) -> Array[UnitSpot]:
	if unit == null:
		return []
	
	return find_targets_for_attack(unit.current_attack)

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
	EventBus.defense_clicked.emit()


func _on_button_wait_pressed() -> void:
	EventBus.wait_clicked.emit()


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
	$"../UI/ParentContainer/PanelContainer/HBoxContainer/TargetHintsContainer/TargetHintsButton".text = new_text
	display_hints()


func _on_button_start_attack_pressed() -> void:
	EventBus.start_attack_clicked.emit()
