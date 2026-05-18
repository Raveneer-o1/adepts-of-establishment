class_name ZonesLayer
extends TileMapLayer

@onready var map: Map = $"../.."

## Mapping between tile coordinates and area index
var tile_to_area: Dictionary[Vector2i, int]

## [codeblock]
## Array[Array[Vector2i]]
## [/codeblock]
var areas: Array[Array]

func get_area(tile: Vector2i) -> Array[Vector2i]:
	var index: int = tile_to_area.get(tile, -1)
	if index < 0: return [] as Array[Vector2i]
	var res: Array[Vector2i] = []
	res.assign(areas[index])
	return res

func _ready() -> void:
	_create_areas.call_deferred()

func _visualize_areas() -> void:
	for area in areas:
		var arg : Array[Vector2i] = []
		arg.assign(area)
		map.visualizer.reset_highlights()
		map.visualizer.highlight_tiles(arg)
		await get_tree().create_timer(0.5).timeout

func _create_areas() -> void:
	var atlas_to_tile := _get_atlas_to_tile_mapping()
	areas = _split_areas(atlas_to_tile)
	_fill_mapping()
	#_visualize_areas()
	

func _fill_mapping() -> void:
	for i in range(areas.size()):
		for t: Vector2i in areas[i]:
			tile_to_area[t] = i

func _split_areas(atlas_to_tile: Dictionary[Vector2i, Array]) -> Array[Array]:
	# atlas_to_tile is Dictionary[Vector2i, Array[Vector2i] ]
	for key in atlas_to_tile:
		atlas_to_tile[key] = _split_area(atlas_to_tile[key])
	# atlas_to_tile is Dictionary[Vector2i, Array[Array[Vector2i]] ]
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
		while all_neighbors:
			var curr_neighbor: Vector2i = all_neighbors.pop_front()
			if curr_neighbor in curr_arr: continue
			if curr_neighbor not in array: continue
			curr_arr.append(curr_neighbor)
			all_neighbors.append_array(get_surrounding_cells(curr_neighbor))
			array.erase(curr_neighbor)
		res.append(curr_arr)  # not append_array() !
	return res

func _get_atlas_to_tile_mapping() -> Dictionary[Vector2i, Array]:
	var atlas_to_tile: Dictionary[Vector2i, Array]
	
	for tile in get_used_cells():
		var atlas_coords := get_cell_atlas_coords(tile)
		(atlas_to_tile.get_or_add(atlas_coords, []) as Array).append(tile)
	
	return atlas_to_tile
