class_name MapEventHandler
extends Node

## Handles player input and interactions on the game map, including mouse and keyboard controls.
##
## The [MapEventHandler] class processes all player inputs related to map
## interaction. [br][br]
##
## By default, direct access to game systems is restricted. The class implements a
## permission system using [method allow_game_access] and [method forbid_game_access]
## to temporarily grant access to sensitive game data like [member Map.active_party].
## This allows input handling methods to work with current game state while maintaining
## the overall architecture where [Faction] classes serve as the primary API for
## external controllers.
##
## The class automatically connects to input events and processes them each frame.
## Game access should be explicitly granted via [method allow_game_access] when
## player interactions require current game state, and revoked with
## [method forbid_game_access] when returning to meta-level operations.

@onready var map: Map = $".."
@onready var visualizer: MapVisualizer = $"../Visualizer"

var terrain_layer: TileMapLayer:
	get: return map.terrain_layer

var camera: MapCamera:
	get: return map.camera

var _game_access_allowed := false

## Returns [member Map.active_party] if game access is permitted or
## [code]null[/code] otherwise. [br][br]
##
## Design rationale: Direct access to game systems is restricted by default,
## with [Faction] classes serving as the primary API for external controllers.
## However, requiring all active-party interactions to go through controllers
## is impractical for [MapEventHandler] methods. [br][br]
##
## Instead, [MapEventHandler] methods can be temporarily granted access via
## [method allow_game_access] and [method forbid_game_access] toggles.
var active_party: MapParty:
	get: return map.active_party if _game_access_allowed else null

## @experimental: currently access permissions are not removed automatically
## Grants [MapEventHandler] direct access to game fields, enabling automatic
## retrieval of properties like [member Map.active_party] during mouse hover,
## click processing, and other player interactions, bypassing the [Faction] API.
## [br][br]
## Incorrect usage may permit unauthorized access or manipulation of other players' data.
func allow_game_access() -> void:
	_game_access_allowed = true
	# TODO: implement automatic access removal

## Revokes direct access to game fields, disabling game-related interactions.
## Only meta-level operations remain available, such as information requests
## or menu navigation.
func forbid_game_access() -> void:
	_game_access_allowed = false

# Last tile coordinates that the mouse was hovering over
var _last_target_tile: Vector2i

# Pathfinding operates with regional segmentation to avoid excessive computation.
# If the player moves the mouse rapidly over tiles far away from the active party,
# algorithm execution is delayed until the cursor position stabilizes.
const _MOUSE_DISTANCE_REGIONS = [
	[15, -1.0],
	[30, 0.05],
	[40, 0.1],
	[50, 0.2],
]
const _MAX_TIMER = 0.5

var _hovering_mouse_coords: Vector2i
var _hovering_timer_active: bool
var _hovering_timer: float

func _set_hovering_timer(t: float) -> void:
	_hovering_timer_active = true
	_hovering_timer = t

# Handles mouse hovering to show pathfinding preview and interactions
func _handle_mouse_hovering() -> void:
	var party := active_party
	if not party: return
	_hovering_mouse_coords = \
		terrain_layer.local_to_map(terrain_layer.get_local_mouse_position())
	if _last_target_tile == _hovering_mouse_coords: return
	_last_target_tile = _hovering_mouse_coords
	var dist := map.get_distance(party.tile_position, _hovering_mouse_coords)
	for region: Array in _MOUSE_DISTANCE_REGIONS:
		if dist < region[0]:
			if region[1] > 0.0: _set_hovering_timer(region[1])
			else: visualizer.draw_path(
				party,
				_hovering_mouse_coords
			)
			break

func _process_click() -> void:
	var tile := map.get_tile_coords()
	if map.active_faction: map.active_faction.api.tile_clicked.emit(tile)
	get_viewport().set_input_as_handled()

func _process_right_click() -> void:
	if not active_party: return
	if active_party.is_moving: return
	map.set_active_party(null)
	visualizer.reset_highlights()
	get_viewport().set_input_as_handled()

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	match event.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			_process_click()
		MouseButton.MOUSE_BUTTON_RIGHT:
			_process_right_click()
		MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom_out()
			get_viewport().set_input_as_handled()
		MouseButton.MOUSE_BUTTON_WHEEL_UP:
			camera.zoom_in()
			get_viewport().set_input_as_handled()

func _handle_camera_key(event: InputEventKey) -> void:
	var key := event.keycode
	var direction := Vector2.ZERO
	match key:
		Key.KEY_D:
			direction += Vector2.RIGHT
		Key.KEY_A:
			direction += Vector2.LEFT
		Key.KEY_S:
			direction += Vector2.DOWN
		Key.KEY_W:
			direction += Vector2.UP
	
	if event.is_released():
		direction = -direction
	camera.start_drift(direction)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		_handle_camera_key(event)
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		_handle_mouse_input(event)
		return
	if event is InputEventMouseMotion:
		_handle_mouse_hovering()

func _process(delta: float) -> void:
	if not _hovering_timer_active: return
	_hovering_timer -= delta
	if _hovering_timer <= 0.0:
		visualizer.draw_path(
			active_party,
			_hovering_mouse_coords
		)
		_hovering_timer_active = false
