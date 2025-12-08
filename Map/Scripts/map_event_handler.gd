class_name MapEventHandler
extends Node

@onready var map: Map = $".."

var terrain_layer: TileMapLayer:
	get: return map.terrain_layer

var camera: MapCamera:
	get: return map.camera

# Last tile coordinates that the mouse was hovering over
var _last_target_tile: Vector2i

# Array of currently highlighted tiles for pathfinding
var _highlighted_tiles: Array[Vector2i] = []

# Flag indicating if highlighted tiles have been consumed for movement
var _highlighted_tiles_were_given: bool = false

# Dictionary mapping color identifiers to atlas coordinates for highlighting
const _ALTERNATIVE_COLOR: Dictionary[StringName, Vector2i] = {
	#"blue" = Vector2i(2, 0),
	"yellow" = Vector2i(1, 0),
}

# Atlas ID for highlight tiles
const _TILE_HIGHLIGHT_ATLAS_ID = 2

# Atlas coordinates for interaction highlight tiles
const _INTERACTION_ATLAS_COORDS = Vector2i(2, 0)

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
	if not map.active_party: return
	_hovering_mouse_coords = \
		terrain_layer.local_to_map(terrain_layer.get_local_mouse_position())
	if _last_target_tile == _hovering_mouse_coords: return
	_last_target_tile = _hovering_mouse_coords
	var dist := map.get_distance(map.active_party.tile_position, _hovering_mouse_coords)
	for region: Array in _MOUSE_DISTANCE_REGIONS:
		if dist < region[0]:
			if region[1] > 0.0: _set_hovering_timer(region[1])
			else: _draw_path()
			break

func _draw_path() -> void:
	var mouse_coords := _hovering_mouse_coords
	
	if map.active_party and not map.active_party.is_moving:
		reset_highlights()
	
	if not map.can_move(map.active_party, mouse_coords): return
	
	var tile_data := terrain_layer.get_cell_tile_data(mouse_coords)
	if not tile_data: 
		return
	
	var object := map.get_first_interactable_object(mouse_coords)
	var path := \
		map.find_path_to_object(
			map.active_party.tile_position,
			object
		) if object else \
		map.find_path(
			map.active_party.tile_position,
			mouse_coords
		)
	
	highlight_tiles(path, map.active_party)
	get_viewport().set_input_as_handled()

func _process_click() -> void:
	var tile := terrain_layer.local_to_map(terrain_layer.get_local_mouse_position())
	get_viewport().set_input_as_handled()
	if map.active_party:
		map.request_active_party_action(tile)
		return
	map.request_player_action(tile)

func _process_right_click() -> void:
	map.set_active_party(null)
	reset_highlights()
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

## Returns the currently highlighted tiles (copy of the array) and marks them as consumed.
## Once tiles are marked as consumed, subsequent calls will return an empty array. [br][br]
##
## [b]Note:[/b] The original highlighted tiles array remains accessible through
## [member MapEventHandler._highlighted_tiles] if direct access is required.
func get_highlighted_tiles() -> Array[Vector2i]:
	if _highlighted_tiles_were_given: return []
	_highlighted_tiles_were_given = true
	return _highlighted_tiles.duplicate()

## Hides highlighted tiles
func reset_highlights() -> void:
	_highlighted_tiles_were_given = false
	for t in _highlighted_tiles:
		map.highlight_layer.set_cell(t)
	_highlighted_tiles.clear()

func _highlight_tiles_w_detection(tiles: Array[Vector2i], party: MapParty) -> void:
	var interacting := false
	for t in tiles:
		# "interacting" check skips calling the functions if we're already intercepting
		if interacting or \
			map.get_first_interception(t, party) or \
			map.get_first_interactable_object(t, party):
				interacting = true
		var atlas_coords := Vector2i(0, 0)
		if interacting:
			atlas_coords = _INTERACTION_ATLAS_COORDS
		else:
			var data := terrain_layer.get_cell_tile_data(t)
			if data:
				var color_name: StringName = data.get_custom_data("color_identifier")
				atlas_coords = _ALTERNATIVE_COLOR.get(color_name, atlas_coords)
		map.highlight_layer.set_cell(t, _TILE_HIGHLIGHT_ATLAS_ID, atlas_coords)
	_highlighted_tiles.append_array(tiles)

func _highlight_tiles_simple(tiles: Array[Vector2i]) -> void:
	for t in tiles:
		var atlas_coords := Vector2i(0, 0)
		var data := terrain_layer.get_cell_tile_data(t)
		if data:
			var color_name: StringName = data.get_custom_data("color_identifier")
			atlas_coords = _ALTERNATIVE_COLOR.get(color_name, atlas_coords)
		map.highlight_layer.set_cell(t, _TILE_HIGHLIGHT_ATLAS_ID, atlas_coords)
	_highlighted_tiles.append_array(tiles)

## Highlights the specified [param tiles] by setting cells in [member Map.highlight_layer].
## [br][br]
## If [param party] is provided, automatically detects interaction points along the path
## and adjusts tile highlighting from that interaction onward.
## This feature requires the tile array to be ordered sequentially.
func highlight_tiles(tiles: Array[Vector2i], party: MapParty = null) -> void:
	if not party: _highlight_tiles_simple(tiles)
	else: _highlight_tiles_w_detection(tiles, party)

func _process(delta: float) -> void:
	if not _hovering_timer_active: return
	_hovering_timer -= delta
	if _hovering_timer <= 0.0:
		_draw_path()
		_hovering_timer_active = false
