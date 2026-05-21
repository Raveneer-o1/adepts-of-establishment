class_name ZonesLayer
extends TileMapLayer

## A layer that defines contiguous tile‑based areas (zones).
##
## An area is simply a set of tiles. How areas are used depends on the specific
## implementation — the most common use is for event triggers (e.g., [MapTrigger_OnEnterArea]).
## [br][br]
## Internally, areas are stored as an array of arrays in [member areas]. To find
## the area containing a particular tile, call [method get_area].
## [br][br]
## To define an area, paint it directly in the TileMap editor. Adjacent cells with
## the same tile color are automatically combined into a single area.
## Overlapping areas are not supported, but areas can have arbitrary shapes.
## [br][br]
## See also: [MapPin]

@onready var map: Map = $"../.."

## Maps each tile coordinate to the index of the area it belongs to.
## The index can be used to retrieve the tile list from [member areas].
var tile_to_area: Dictionary[Vector2i, int]

## [codeblock]
## Array[Array[Vector2i]]
## [/codeblock]
var areas: Array[Array]

## Returns the area (array of tile coordinates) that contains the given [param tile].
## If no area exists, returns an empty array.
func get_area(tile: Vector2i) -> Array[Vector2i]:
	var index: int = tile_to_area.get(tile, -1)
	if index < 0: return [] as Array[Vector2i]
	var res: Array[Vector2i] = []
	res.assign(areas[index])
	return res

func _ready() -> void:
	_create_areas.call_deferred()

func _visualize_areas() -> void:
	if not OS.is_debug_build(): hide()
	for area in areas:
		var arg : Array[Vector2i] = []
		arg.assign(area)
		map.visualizer.reset_highlights()
		map.visualizer.highlight_tiles(arg)
		await get_tree().create_timer(0.5).timeout

func _create_areas() -> void:
	# Group tiles by their atlas coordinate (tile color)
	var atlas_to_tile := _get_atlas_to_tile_mapping()
	
	# Split each atlas group into contiguous areas
	areas = _split_areas(atlas_to_tile)
	
	_fill_mapping()  # fill tile_to_area mapping
	#_visualize_areas()  # Debug visualization

func _fill_mapping() -> void:
	for i in range(areas.size()):
		for t: Vector2i in areas[i]:
			tile_to_area[t] = i

func _split_areas(atlas_to_tile: Dictionary[Vector2i, Array]) -> Array[Array]:
	# "atlas_to_tile" is now Dictionary[Vector2i, Array[Vector2i] ]
	for key in atlas_to_tile:
		atlas_to_tile[key] = _split_area(atlas_to_tile[key])
	
	# "atlas_to_tile" is now Dictionary[Vector2i, Array[Array[Vector2i]] ]
	
	# Flatten all areas into a single array
	var res: Array[Array] = []
	for key in atlas_to_tile:
		res.append_array(atlas_to_tile[key])
	return res

func _split_area(array: Array) -> Array[Array]:
	var res: Array[Array] = []
	var closed_set: Dictionary[Vector2i, int] = {}
	while array:
		var tile: Vector2i = array.pop_front()
		var curr_arr := [tile]
		var all_neighbors := get_surrounding_cells(tile)
		
		# Flood fill to find connected components
		while all_neighbors:
			var curr_neighbor: Vector2i = all_neighbors.pop_front()
			if curr_neighbor in curr_arr: continue
			if curr_neighbor not in array: continue
			curr_arr.append(curr_neighbor)
			all_neighbors.append_array(get_surrounding_cells(curr_neighbor))
			array.erase(curr_neighbor)  # Remove from pool
		res.append(curr_arr)  # not append_array() !
	return res

func _get_atlas_to_tile_mapping() -> Dictionary[Vector2i, Array]:
	var atlas_to_tile: Dictionary[Vector2i, Array]
	
	for tile in get_used_cells():
		var atlas_coords := get_cell_atlas_coords(tile)
		(atlas_to_tile.get_or_add(atlas_coords, []) as Array).append(tile)
	
	return atlas_to_tile
