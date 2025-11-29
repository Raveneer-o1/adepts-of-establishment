class_name MapEventHandler
extends Node

@onready var map: Map = $".."

var terrain_layer: TileMapLayer:
	get: return map.terrain_layer

var camera: Camera2D:
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

# Handles mouse hovering to show pathfinding preview and interactions
func _handle_mouse_hovering() -> void:
	var mouse_coords := terrain_layer.local_to_map(terrain_layer.get_local_mouse_position())
	if _last_target_tile == mouse_coords: return
		
	var objects := map.get_objects_on_tile(mouse_coords)
	if not map.can_move(map.active_party, objects): return
	
	_reset_highlights()
	
	var tile_data := terrain_layer.get_cell_tile_data(mouse_coords)
	if not tile_data: 
		return
	
	var interaction := false
	for o in objects:
		if o.request_interaction(map.active_party): interaction = true; break
	
	var path := map.find_path(
		map.active_party.tile_position,
		mouse_coords
	)
	
	# TODO: replace this abomination with normal O(n)
	if not interaction:
		for tile in path:
			for o in map.get_objects_on_tile(tile):
				if o.request_interaction(map.active_party): interaction = true; break
			if interaction: break
	
	_last_target_tile = mouse_coords
	_highlight_tiles(path, interaction)
	get_viewport().set_input_as_handled()

func _process_click() -> void:
	var tile := terrain_layer.local_to_map(terrain_layer.get_local_mouse_position())
	if map.active_party:
		map.request_active_party_interaction(tile)
		get_viewport().set_input_as_handled()
		return
	map.request_player_interaction(tile)

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	match event.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			_process_click()
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

## Returns the currently highlighted tiles and marks them as consumed.
## Once tiles are marked as consumed, subsequent calls will return an empty array. [br][br]
##
## [b]Note:[/b] The original highlighted tiles array remains accessible through
## [member MapEventHandler._highlighted_tiles] if direct access is required.
func get_highlighted_tiles() -> Array[Vector2i]:
	if _highlighted_tiles_were_given: return []
	_highlighted_tiles_were_given = true
	return _highlighted_tiles.duplicate()

func _reset_highlights() -> void:
	_highlighted_tiles_were_given = false
	for t in _highlighted_tiles:
		map.highlight_layer.set_cell(t)
	_highlighted_tiles.clear()

func _highlight_tiles(tiles: Array[Vector2i], interaction: bool = false) -> void:
	for t in tiles:
		var atlas_coords := Vector2i(0, 0)
		if interaction:
			atlas_coords = _INTERACTION_ATLAS_COORDS
		else:
			var data := terrain_layer.get_cell_tile_data(t)
			if data:
				var color_name: StringName = data.get_custom_data("color_identifier")
				atlas_coords = _ALTERNATIVE_COLOR.get(color_name, atlas_coords)
		map.highlight_layer.set_cell(t, _TILE_HIGHLIGHT_ATLAS_ID, atlas_coords)
	_highlighted_tiles.append_array(tiles)
