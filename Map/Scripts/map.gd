class_name Map
extends Node2D

## Map node. Handles map related actions.
##

## This layer should contain [code]traverse_cost[/code] custom
## data layer with [b]int[/b] type (value of -1 means the tile is not traversable)
@onready var terrain_layer : TileMapLayer = %TerrainLayer
@onready var objects_layer : TileMapLayer = %ObjectsLayer
@onready var highlight_layer: TileMapLayer = %HighlightLayer

@onready var camera: MapCamera = $Camera2D
@onready var path_finder: PathFinder = $PathFinder

@onready var active_party: MapParty = $Parties/MapParty

## Returns the global coordinates for the specified tile
func get_global_coords(tile_coord: Vector2i) -> Vector2:
	return terrain_layer.to_global(terrain_layer.map_to_local(tile_coord))

## Returns the distance between two hex positions in axial coordinates. [br]
## Note: This function assumes axial coordinate system
## (Godot's [i]Stairs[/i] or [i]Diamond[/i] layouts)
## and will not produce correct results with offset coordinates
## (Godot's [i]Stacked[/i] layout).
func get_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	var diff: Vector2i = pos1 - pos2
	var dz := absi(diff.x + diff.y)
	diff = abs(diff)
	return (diff.x + diff.y + dz) >> 1

## Gets all neighboring tiles for a given coordinate
func get_neighbors(coords: Vector2i) -> Array[Vector2i]:
	return [
		terrain_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE),
		terrain_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE),
		terrain_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE),
		terrain_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE),
		terrain_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE),
		terrain_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE),
	]

func find_path(start: Vector2i, end: Vector2i, travel_data: TravelData) -> Array[Vector2i]:
	#TODO: construct TravelData object from Party provided
	return path_finder.A_star(start, end, travel_data)

func _ready() -> void:
	active_party.map = self
	active_party.walk_to(Vector2i(23, 16))

func _handle_mouse_hovering() -> void:
	if active_party._is_moving: return
	
	var mouse_coords := terrain_layer.local_to_map(get_local_mouse_position())
	if last_target_tile == mouse_coords: return
	
	_reset_highlights()
	var tile_data := terrain_layer.get_cell_tile_data(mouse_coords)
	if not tile_data: 
		return
	
	var path := find_path(
		active_party.tile_position,
		mouse_coords,
		TravelData.new()
	)
	last_target_tile = mouse_coords
	_highlight_tiles(path)
	get_viewport().set_input_as_handled()

func _handle_mouse_input(event: InputEventMouse) -> void:
	#print(event.button_mask)
	
	# TODO: rework this temporary solution
	match event.button_mask:
		MouseButton.MOUSE_BUTTON_NONE:
			_handle_mouse_hovering()
		MouseButton.MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			await active_party.walk_along_path(_highlighted_tiles)
		1 << (MouseButton.MOUSE_BUTTON_WHEEL_DOWN - 1):
			camera.zoom_out()
			get_viewport().set_input_as_handled()
		1 << (MouseButton.MOUSE_BUTTON_WHEEL_UP - 1):
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
	_handle_camera_key(event)
	get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		_handle_mouse_input(event)

var last_target_tile: Vector2i
var _highlighted_tiles: Array[Vector2i]

func _reset_highlights() -> void:
	for t in _highlighted_tiles:
		highlight_layer.set_cell(t)
	_highlighted_tiles.clear()

const _ALTERNATIVE_COLOR: Dictionary[StringName, Vector2i] = {
	#"blue" = Vector2i(2, 0),
	"yellow" = Vector2i(1, 0),
}
const _TILE_HIGHLIGHT_ATLAS_ID = 2

func _highlight_tiles(tiles: Array[Vector2i]) -> void:
	for t in tiles:
		var data := terrain_layer.get_cell_tile_data(t)
		var atlas_coords := Vector2i(0, 0)
		if data:
			var color_name: StringName = data.get_custom_data("color_identifier")
			atlas_coords = _ALTERNATIVE_COLOR.get(color_name, atlas_coords)
		highlight_layer.set_cell(t, _TILE_HIGHLIGHT_ATLAS_ID, atlas_coords)
	_highlighted_tiles.append_array(tiles)
