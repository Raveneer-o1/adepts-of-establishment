class_name Map
extends Node2D

## Map node. Handles map related actions.
##
## [member terrain_layer] should contain [code]traverse_cost[/code] custom
## data layer with [b]int[/b] type (value of -1 means the tile is not traversable) [br]
## The rules for this layer are: [br][br]
## > 0: the base cost for the party to traverse this tile[br]
## = 0 (aka [b]"hard block"[/b]): the tile can never be traversed.[br]
## < 0 (aka [b]"soft block"[/b]): the tile is normally not traversable but in
##      special cases (e.g. flying party)
##      the cost is the absolute value of the provided value.

@onready var terrain_layer : TileMapLayer = %TerrainLayer
@onready var objects_layer : TileMapLayer = %ObjectsLayer

## Represents a node in the A* pathfinding algorithm
class PathNode extends RefCounted:
	var tile_coords: Vector2i
	var came_from: PathNode
	var terrain_cost: int
	var accumulated_cost: int
	
	func _init(coords: Vector2i, terrain_layer: TileMapLayer, from: PathNode = null) -> void:
		var tile_data := terrain_layer.get_cell_tile_data(tile_coords)
		terrain_cost = tile_data.get_custom_data("traverse_cost")
		tile_coords = coords
		came_from = from
		
		if came_from:
			accumulated_cost = absi(terrain_cost) + came_from.accumulated_cost
		else:
			accumulated_cost = absi(terrain_cost)

## Contains travel parameters that affect pathfinding behavior
class TravelData extends RefCounted:
	# TODO: traversable tiles mask
	var cost_multiplier: int = 1
	var ignore_soft_blocks: bool = false

## Finds a path from start to end using A* algorithm [br][br]
## [param start]: Starting tile coordinates[br]
## [param end]: Destination tile coordinates[br]
## [param travel_data]: Travel parameters that affect pathfinding[br]
## @return: Array of tile coordinates representing the path from start to end (excluding start)
func find_path(start: Vector2i, end: Vector2i, travel_data: TravelData) -> Array[Vector2i]:
	if start == end: 
		return []
	
	if not _are_tiles_valid(start, end, travel_data):
		return []
	
	var current_node := PathNode.new(start, terrain_layer)
	var closed_set: Dictionary[Vector2i, PathNode] = {}  # Tiles that have been evaluated
	var open_set: Dictionary[Vector2i, PathNode] = {}    # Tiles to be evaluated
	const MAX_ITERATIONS = 1000
	
	# A* algorithm main loop
	for iteration in range(MAX_ITERATIONS):
		# WARNING: remove this two lines
		_visualize_current_tile(current_node.tile_coords)
		await get_tree().create_timer(0.1).timeout
		
		# Evaluate all neighbors of the current tile
		_evaluate_neighbors(current_node, open_set, closed_set, travel_data)
		
		closed_set[current_node.tile_coords] = current_node
		
		# Check if we reached the destination
		if current_node.tile_coords == end: 
			break
		
		var next_node := _get_next_node(open_set, end)
		if next_node:
			current_node = next_node
		else:
			break  # No more nodes to evaluate
	
	if not closed_set.has(end):
		return []
	
	return _reconstruct_path(closed_set[end], start)

func _are_tiles_valid(start: Vector2i, end: Vector2i, travel_data: TravelData) -> bool:
	var start_tile := terrain_layer.get_cell_tile_data(start)
	var end_tile := terrain_layer.get_cell_tile_data(end)
	
	if not start_tile or not end_tile:
		return false
	
	var start_cost: int = start_tile.get_custom_data("traverse_cost")
	var end_cost: int = end_tile.get_custom_data("traverse_cost")
	
	# Check for hard blocks (cost = 0)
	if start_cost == 0 or end_cost == 0:
		return false
	
	# Check for soft blocks if not ignored
	if not travel_data.ignore_soft_blocks and (start_cost < 0 or end_cost < 0):
		return false
	
	return true

func _evaluate_neighbors(
	current_node: PathNode, 
	open_set: Dictionary, 
	closed_set: Dictionary, 
	travel_data: TravelData
) -> void:
	for neighbor_coords in get_neighbors(current_node.tile_coords):
		if neighbor_coords in closed_set:
			if not closed_set[neighbor_coords].came_from: 
				continue
			if closed_set[neighbor_coords].came_from.accumulated_cost > \
			current_node.accumulated_cost:
				closed_set[neighbor_coords].came_from = current_node
				closed_set[neighbor_coords].accumulated_cost = \
					current_node.accumulated_cost + \
					closed_set[neighbor_coords].terrain_cost
		else:
			if neighbor_coords in open_set:
				continue
			
			var neighbor_data := terrain_layer.\
				get_cell_tile_data(neighbor_coords)
			if not neighbor_data: continue
			var neighbor_cost: int = neighbor_data.\
				get_custom_data("traverse_cost")
			if neighbor_cost == 0 or \
				(neighbor_cost < 0 and not travel_data.ignore_soft_blocks):
				continue
			
			open_set[neighbor_coords] = \
				PathNode.new(neighbor_coords, terrain_layer, current_node)

## Heuristic function for A* (estimated cost from current position to goal)
func heuristic(current_pos: Vector2i, goal_pos: Vector2i) -> int:
	var diff: Vector2i = current_pos - goal_pos
	var dz := absi(diff.x + diff.y)
	diff = abs(diff)
	return diff.x + diff.y + dz

# Finds the next node to evaluate from the open set using A* scoring
func _get_next_node(open_set: Dictionary[Vector2i, PathNode], goal: Vector2i) -> PathNode:
	if not open_set: 
		return null 
	
	var best_node_coords := Vector2i.ZERO
	var min_score := -1
	var is_first := true
	
	for coords in open_set:
		var node := open_set[coords]
		var score := node.accumulated_cost + heuristic(node.tile_coords, goal)
		
		if is_first or score < min_score:
			min_score = score
			best_node_coords = coords
			is_first = false
	
	var result := open_set[best_node_coords]
	open_set.erase(best_node_coords)
	return result

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

func _reconstruct_path(end_node: PathNode, start_coords: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var current_node := end_node
	
	while current_node.tile_coords != start_coords:
		path.append(current_node.tile_coords)
		current_node = current_node.came_from
	
	return path

func _visualize_current_tile(tile_coords: Vector2i) -> void:
	terrain_layer.set_cell(tile_coords, 2, Vector2i(randi() % 7, randi() % 7))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.button_mask == MouseButton.MOUSE_BUTTON_LEFT:
			var mouse_coords := terrain_layer.local_to_map(get_local_mouse_position())
			var tile_data := terrain_layer.get_cell_tile_data(mouse_coords)
			if not tile_data: 
				return
			
			var path := await find_path(Vector2i(23, 16), mouse_coords, TravelData.new())
			print("Path length: %d" % path.size())
			
			for path_tile in path:
				terrain_layer.set_cell(path_tile)
