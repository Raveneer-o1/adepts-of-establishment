class_name MapVisualizer
extends Node

@onready var map: Map = $".."
@onready var tile_data_layer: Node2D = %TileDataLayer

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

func _should_draw(party: MapParty, tile: Vector2i) -> bool:
	if not party: return false
	if party.is_moving: return false
	return true

func _find_path(party: MapParty, destination: Vector2i) -> Array[Vector2i]:
	var object := map.get_first_interactable_object(destination)
	var start: Array[Vector2i] = [party.tile_position]
	var include_start := false
	if party.inside_city:
		start = party.inside_city.get_interaction_tiles(party)
		include_start = true
	return \
		map.find_path_to_object(
			start,
			object,
			party,
			include_start
		) if object else \
		map.find_path(
			start,
			destination,
			party,
			include_start
		)

# ATTENTION: this function is prone to errors and can cause crashes if 
# called incorrectly. Read the docscting.
## Draws a path for the specified [param party] to [param end] from [param start].
## Note operand order: draws path TO end FROM start. [br]
## If [param start] is omitted, uses [member MapParty.tile_position], requiring
## [param party] to be non-null or the game will crash.
## [color=red]Caller must verify this condition.[/color]
func draw_path(
	party: MapParty,
	end: Vector2i,
	start: Vector2i = party.tile_position
) -> void:
	if party and not party.is_moving:
		reset_highlights()
	
	if not _should_draw(party, end): return
	
	var tile_data := map.terrain_layer.get_cell_tile_data(end)
	if not tile_data: 
		return
	
	var path := _find_path(party, end)
	
	highlight_tiles(path, party)
	#get_viewport().set_input_as_handled()


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
		if not interacting:
			if map.get_first_interception(t, party):  # or \
			#map.get_first_interactable_object(t, party):
				interacting = true
		var atlas_coords := Vector2i(0, 0)
		if interacting:
			atlas_coords = _INTERACTION_ATLAS_COORDS
		else:
			var data := map.terrain_layer.get_cell_tile_data(t)
			if data:
				var color_name: StringName = data.get_custom_data("color_identifier")
				atlas_coords = _ALTERNATIVE_COLOR.get(color_name, atlas_coords)
		map.highlight_layer.set_cell(t, _TILE_HIGHLIGHT_ATLAS_ID, atlas_coords)
	_highlighted_tiles.append_array(tiles)

func _highlight_tiles_simple(tiles: Array[Vector2i]) -> void:
	for t in tiles:
		#await get_tree().create_timer(0.1).timeout
		var atlas_coords := Vector2i(0, 0)
		var data := map.terrain_layer.get_cell_tile_data(t)
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

func _check_show_tile_ownership() -> void:
	tile_data_layer.visible = GameSettings.show_tile_ownership

func _ready() -> void:
	GameSettings.show_tile_ownership_changed.connect(_check_show_tile_ownership)
	tile_data_layer.visible = GameSettings.show_tile_ownership
