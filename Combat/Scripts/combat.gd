class_name CombatSystem
extends Node2D

## The main combat component
##
## Serves as the orchestrator and interface layer that coordinates between different
## combat subsystems and handles external interactions.[br][br]
##
## This class does not handle the overall logic of combat. That is the job of a dedicated
## class - [CombatLogic] - that drives the actual combat mechanics.
## Essentially, [CombatSystem] receives notifications that something should happen
## (e.g., when the player clicks a unit, [method choose_unit] is called),
## and after consulting [CombatLogic], responds accordingly.[br][br]
##
## The combat scene consists of two [Party] nodes, two [PlayerAPI] nodes,
## a [CombatLogic] node, and some helper nodes like [member active_unit_marker].[br][br]
##
## Combat Structure:[br]
## [i]Battle[/i]: The entire combat encounter from start to finish.[br]
## [i]Round[/i]: A complete cycle where all units have an opportunity to act. More specifically,
## during a round, each [UnitAttack] is attended to exactly once.[br]
## [i]Turn[/i]: A single unit's action.[br][br]
##
## Turns are ordered by [member UnitAttack.initiative], independent of the parties.
## The ordered [UnitAttack]s form an [i]action queue[/i].[br][br]
##
## The most important concept in combat is the turn. Each turn is an opportunity to perform
## exactly one action. This action can be taking a [i]defense[/i] stance, [i]waiting[/i],
## or [i]attacking[/i] (see [Unit] for more details).
## The attack action is performed in several stages:[br]
## - Target Validation[br]
## - Attack Booking[br]
## - Effect Application[br]
## - Resolution[br]
## - Finalization[br]
## - Cleanup[br]
## For more details see [Attack].[br][br]
##
## [b]Other Notes[/b][br]
## Extend through component composition rather than inheritance. This applies to
## the majority of this project. Unless a class is specifically designed to be overridden,
## composition is always preferable to inheritance.[br]
## For detailed implementation guides on these subsystems, refer to the [Unit] and
## [UnitAttack] documentation. [br]
## [b]See also:[/b] [Unit], [UnitAttack], [Attack]

# Temporary label scene for displaying text near units
const TEMP_LABEL = preload("res://Combat/Scenes/TempLabel.tscn")

const _DISTANCE_TO_LABEL = 45.0
const SQRT_2 = sqrt(2.0)
const UNIT_SPOT = preload("res://Combat/Scenes/unit_spot.tscn")


const SHOW_HINTS_NEVER = 0
const SHOW_HINTS_ALWAYS = 1
const SHOW_HINTS_ON_HOVER = 2
## Number of states show_hitns_mode can have
const SHOW_HINTS_MAX = 3

const WIN_LABEL_LINE = "[center][color=green]%s[/color][/center]"
const TIME_TO_END = 2.5

# Configuration variables for parties
@export var left_party_units: Array[UnitData]
@export var right_party_units: Array[UnitData]

## Contains a dictionary of baseline unit parameters for reference purposes.
## Not used for unit initialization and does not trigger validation failures when stats differ.
## This is intentional - units often have modified stats (e.g., from global buffs),
## making comparison to default values irrelevant.
## Use this database when "dry" baseline stats are needed. [br]
## [color=yellow]Note:[/color] Do not populate this database manually - use the 
## dedicated script in the [i]UnitStatsManager/[/i] directory.
## @experimental: Currently not implemented
@export var unit_parameters_database: Resource

@export var unit_marker: Resource

@export var left_player: PlayerAPI
@export var right_player: PlayerAPI


## Predefined positions for label placement to prevent overlap.[br]
## Using random positioning often results in labels being too close, making them unreadable.[br]
## This array is shuffled at game start. 
## Use the getter [member label_position] to retrieve positions sequentially.
const label_positions : Array[Vector2] = [
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

## This getter advances [member current_label_position] and returns the next 
## position from [member label_positions]
var label_position: Vector2:
	get:
		current_label_position += 1
		current_label_position = current_label_position % label_positions_length
		return label_positions[current_label_position]

var loaded_units: Dictionary[String, Resource] = {}
var highlighted_units: Array[UnitSpot] = []

var _current_unit: Unit
## Reference to the current active unit in combat. The setter also manages 
## [member active_unit_marker].
var current_unit: Unit:
	get:
		return _current_unit
	set(value):
		_current_unit = value
		if value == null or value.parameters.dead:
			active_unit_marker.visible = false
			current_player = null
		else:
			active_unit_marker.position = value.global_position
			active_unit_marker.visible = true
			current_player = value.party.player

var _current_player: PlayerAPI
## Reference to the current active player in combat. The setter also sets 
## [member PlayerAPI.disabled] flags.
var current_player: PlayerAPI:
	get:
		return _current_player
	set(value):
		if _current_player == value: return
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
@onready var active_unit_marker: AnimatedSprite2D = get_node("ActiveUnitMarker")
@onready var win_label: RichTextLabel = get_node("Win Label")
@onready var miniature_queue_manager: MiniatureQueueManager = \
	$"../UI/ParentContainer/PanelContainer/HBoxContainer/Queue"


## Checks if any party is empty and determines a winner
func check_winner(_unit: Unit = null) -> void:
	if timer != null:
		return
	var left_empty := left_party.check_if_empty()
	var right_empty := right_party.check_if_empty()
	if left_empty and right_empty:
		win_label.text = WIN_LABEL_LINE % "Tie!"
	elif left_empty:
		win_label.text = WIN_LABEL_LINE % "Right wins!"
	elif right_empty:
		win_label.text = WIN_LABEL_LINE % "Left wins!"
	else:
		return
	combat_logic.end_battle()

## Handles the resolution of all attacks and prepares for the next combat stage
func finish_attack() -> void:
	combat_logic.resolve_and_finalize_all_attacks()
	for spot in highlighted_units:
		if spot != null:
			spot.reset_highlight()
	highlighted_units.clear()
	combat_logic.next_stage()

## Called when an attack is finished.[br]
## Checks if the attack was of an active unit and triggers attack resolution if it was
func check_finished_animation(unit: Unit) -> void:
	if unit == current_unit:
		finish_attack()
		clear_emittings()

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
	if not combat_logic.try_wait():
		return false
	
	miniature_queue_manager.shift_miniature(combat_logic.current_attack)
	combat_logic.next_stage(false)
	
	return true


func try_taking_defense_stance() -> bool:
	if current_unit.try_take_defense_stance():
		combat_logic.next_stage()
		return true
	return false


func start_attacking_chosen_targets() -> void:
	current_unit.start_attacking()


## Attempts to move [param unit] to the specified position [param pos], 
## swapping with any unit already there.
## Returns [code]true[/code] if the move was successful, [code]false[/code] otherwise. [br]
## If the target position is occupied, the units will swap places. For non-swapping movement,
## use [method try_moving_unit] instead.
## @experimental: large units are not supported. Method will return false.
func try_swapping_units(unit: Unit, pos: int) -> bool:
	if not unit: return false
	if unit.parameters.large_unit: return false
	if pos < 0 or pos >= Party.MAX_UNITS_NUMBER: return false
	var party: Party = unit.party
	
	var another_unit: Unit = null
	if party.unitsrelease_unit[pos]:
		another_unit = party.units[pos]
		if another_unit.parameters.large_unit: return false
		party.unit_spots[pos].release_unit()
	
	var old_pos: int = unit.spot.party_position
	unit.spot.release_unit()
		
	party.unit_spots[pos].assign_unit(unit)
	EventBus.unit_moved.emit(unit, old_pos)
	if another_unit:
		party.unit_spots[old_pos].assign_unit(another_unit)
		EventBus.unit_moved.emit(another_unit, pos)
	return false

## Attempts to move [param unit] to the specified position [param pos].
## Returns [code]true[/code] if the move was successful, [code]false[/code] otherwise. [br]
## If the target position is occupied, method returns [code]false[/code].
## For swapping behavior, use [method try_swapping_units] instead.
## @experimental: large units are not supported. Method will return false.
func try_moving_unit(unit: Unit, pos: int) -> bool:
	if not unit: return false
	if unit.parameters.large_unit: return false
	if pos < 0 or pos >= Party.MAX_UNITS_NUMBER: return false
	var party: Party = unit.party
	if party.unit_spots[pos].unit: return false
	
	var old_pos: int = unit.spot.party_position
	unit.spot.release_unit()
	party.unit_spots[pos].assign_unit(unit)
	EventBus.unit_moved.emit(unit, old_pos)
	return true

#region Display text

## Interval for the first text to be displayed after triggering
const FIRST_TEXT_DISPLAYED_INTERVAL = 0.01
## Default interval between consecutive text displays
const TEXT_DISPLAYED_INTERVAL = 0.1
## Interval after which text display process is aborted
const TEXT_DISPLAYED_ABORT_INTERVAL = TEXT_DISPLAYED_INTERVAL * 2

## Tracks whether any text was recently displayed
var text_displayed: bool = false
## Timer for how long text display has been active or idle
var text_displayed_time: float = TEXT_DISPLAYED_ABORT_INTERVAL

## A class representing text to be displayed near a unit
class DisplayedText:
	var unit: Unit
	var text: String
	var color: Color = Color.WHITE
	
	func _init(u: Unit, t: String, c: Color = Color.WHITE) -> void:
		unit = u
		text = t
		color = c

## Queue of texts to be displayed, each associated with a specific unit
var texts_to_display: Array[DisplayedText] = []

## Adds a vanishing message near a unit bypassing the display process
func display_text_near_unit_async(unit: Unit, text: String, color: Color = Color.WHITE) -> void:
	var offset := label_position
	var lbl: Label = TEMP_LABEL.instantiate()
	unit.add_child(lbl)
	
	lbl.text = text
	lbl.set_begin(unit.global_position + offset)
	lbl.modulate = color

## Adds a vanishing message near a unit and starts the display process
func display_text_near_unit(unit: Unit, text: String, color: Color = Color.WHITE) -> void:
	var text_to_display: DisplayedText = DisplayedText.new(unit, text, color)
	texts_to_display.append(text_to_display)
	
	if not text_displayed:
		text_displayed = true
		get_tree().create_timer(FIRST_TEXT_DISPLAYED_INTERVAL).\
				timeout.connect(display_next_text)

# Displays a text label near the given unit. It's not recommended to use this method directly,
# because it's possible to print too much text on the screen at the same time
func _display_text_near_unit(d_text: DisplayedText) -> void:
	text_displayed = true
	text_displayed_time = TEXT_DISPLAYED_ABORT_INTERVAL 
	
	var offset := label_position
	var lbl: Label = TEMP_LABEL.instantiate()
	d_text.unit.add_child(lbl)
	
	lbl.text = d_text.text
	lbl.set_begin(d_text.unit.global_position + offset)
	lbl.modulate = d_text.color

## Displays the next queued text and handles overlap between units
func display_next_text() -> void:
	if texts_to_display.is_empty():
		text_displayed = false
		text_displayed_time = TEXT_DISPLAYED_ABORT_INTERVAL
		return
	
	var next_text: DisplayedText = texts_to_display.pop_front()
	_display_text_near_unit(next_text)
	
	# Schedule the next text display
	get_tree().create_timer(TEXT_DISPLAYED_INTERVAL). \
			timeout.connect(display_next_text)

#endregion

#region UI utilities

func remove_miniature(atk: UnitAttack) -> void:
	miniature_queue_manager.remove_miniature(atk)

func clear_nearest_miniature() -> void:
	miniature_queue_manager.clear_nearest_miniature()

func fill_miniatures_queue() -> void:
	miniature_queue_manager.fill_queue(combat_logic.attacks_queue)

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
			var avaliable_targets: Array[UnitSpot] = find_avaliable_targets()
			for target in avaliable_targets:
				var marker: AnimatedSprite2D = unit_marker.instantiate()
				displayed_hints.append(marker)
				target.add_child(marker)
				marker.modulate = Color.FOREST_GREEN
		SHOW_HINTS_ON_HOVER:
			var avaliable_targets := find_avaliable_targets()
			for spot in left_party.unit_spots + right_party.unit_spots:
				if spot == null:
					continue
				var color: Color = Color.FIREBRICK
				if avaliable_targets.has(spot):
					color = Color.FOREST_GREEN
				spot.area_2d.get_node("HighlightAnimation").modulate = color

#endregion

#region Initialization
func load_unit_list(list: Array[UnitData]) -> void:
	for unit_data in list:
		var path := unit_data.scene_path
		if not path.is_empty() and not loaded_units.has(path):
			var resource := load(path)
			if resource: loaded_units[path] = resource
			else: push_error("Resource not found: " + path)
			await get_tree().process_frame

func load_units() -> void:
	await load_unit_list(left_party_units)
	await load_unit_list(right_party_units)

func check_refs_validity() -> bool:
	var are_refs_valid: bool = true
	
	if (not is_instance_valid(left_party)) or \
		left_party == null or \
		left_party.is_queued_for_deletion():
			push_error("Left party is not found!")
			are_refs_valid = false
	
	if (not is_instance_valid(right_party)) or \
		right_party == null or \
		right_party.is_queued_for_deletion():
			push_error("Right party is not found!")
			are_refs_valid = false
	
	if (not is_instance_valid(left_player)) or \
		left_player == null or \
		left_player.is_queued_for_deletion():
			push_error("Left player is not found!")
			are_refs_valid = false
	
	if (not is_instance_valid(right_player)) or \
		right_player == null or \
		right_player.is_queued_for_deletion():
			push_error("Right player is not found!")
			are_refs_valid = false
	
	return are_refs_valid

func initialize_variables() -> void:
	if not check_refs_validity():
		end_scene()
		return
	
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
	left_party_units = EventBus.left_units
	right_party_units = EventBus.right_units

func place_units() -> void:
	await right_party.place_units(right_party_units)
	await left_party.place_units(left_party_units)

func _ready() -> void:
	initialize_variables()
	
	# loading the scene combat with pauses for one frame after each heavy iteration
	# this doesn't always work and starting combat does introduce some stutter
	# but threads are more complicated to implement - this will do for now
	await get_tree().process_frame
	await load_units()
	await get_tree().process_frame
	await place_units()
	await get_tree().process_frame
	combat_logic.start_battle()
	EventBus.is_battle_ready = true
#endregion

#region Utilities

## Clears connections from [signal EventBus.attack_animation_finished].
## This ensures effects disconnect from these signals and prevents unwanted trigger accumulation.
## Allows effect design without manual connection cleanup.
func clear_emittings() -> void:
	for d: Dictionary in EventBus.attack_animation_finished.get_connections():
		EventBus.attack_animation_finished.disconnect(d.callable)
	EventBus.attack_animation_finished.connect(check_finished_animation)

func find_targets_for_attack(attack: UnitAttack) -> Array[UnitSpot]:
	if attack == null:
		return []
	if not attack.target_validation:
		print_debug("Trying to address empty target validation!")
		return []
	
	var result: Array[UnitSpot] = []
	var all_unit_spots: Array[UnitSpot] = left_party.unit_spots + right_party.unit_spots
	
	for spot in all_unit_spots:
		if spot == null:
			continue
		if attack.target_validation.validate_target(attack.unit, spot):
			result.append(spot)
	
	return result

func find_avaliable_targets(unit: Unit = current_unit) -> Array[UnitSpot]:
	if unit == null:
		return []
	
	return find_targets_for_attack(unit.current_attack)

## Emits [signal EventBus.battle_ended].
## Parent scene is expected to free the combat scene.
func end_scene() -> void:
	EventBus.battle_ended.emit()
	#queue_free()
	#if EventBus.packed_menu == null:
		#get_tree().change_scene_to_file("res://Menu/Scenes/menu.tscn")
	#else:
		#get_tree().change_scene_to_packed(EventBus.packed_menu)


## Starts a countdown timer for [member TIME_TO_END] seconds.
## When the timer expires, the menu scene will be loaded.
## The created timer is stored in [member timer].
## Safe to call multiple times - has no effect if [member timer] already exists.
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
	$"../UI/ParentContainer/PanelContainer/HBoxContainer/TargetHintsContainer/TargetHintsButton"\
		.text = new_text
	display_hints()


func _on_button_start_attack_pressed() -> void:
	EventBus.start_attack_clicked.emit()

func _process(delta: float) -> void:
	if text_displayed:
		text_displayed_time -= delta
		if text_displayed_time <= 0:
			push_error("Interval missed! Aborting display interval...")
			text_displayed = false
			text_displayed_time = TEXT_DISPLAYED_ABORT_INTERVAL
			texts_to_display.clear()

@onready var switch_action_button: Button = \
	$"../UI/ParentContainer/PanelContainer/HBoxContainer/ButtonSwitchAction"

const SWITCH_ACTION_TEXT = "Switch action:\n%s"

func update_switch_button_text() -> void:
	switch_action_button.disabled = current_unit.alternative_action_count <= 0
	switch_action_button.text = SWITCH_ACTION_TEXT % current_unit.current_attack.attack_name

func _on_button_switch_action_pressed() -> void:
	if not current_unit.try_switch_action():
		print("Unable to switch!")
	else: update_switch_button_text()
