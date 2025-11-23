class_name PathFinder
extends Node

@onready var map: Map = $".."

var terrain_layer: TileMapLayer:
	get:
		return map.terrain_layer

## Represents a node in the A* pathfinding algorithm
class PathNode extends RefCounted:
	var tile_coords: Vector2i
	var came_from: PathNode
	var terrain_cost: int
	var accumulated_cost: int
	
	func _init(coords: Vector2i, terrain_layer: TileMapLayer, from: PathNode = null) -> void:
		var tile_data := terrain_layer.get_cell_tile_data(coords)
		terrain_cost = tile_data.get_custom_data("traverse_cost")
		tile_coords = coords
		came_from = from
		
		if came_from:
			accumulated_cost = absi(terrain_cost) + came_from.accumulated_cost
		else:
			accumulated_cost = absi(terrain_cost)

## Finds a path from start to end using A* algorithm [br][br]
## [param start]: Starting tile coordinates[br]
## [param end]: Destination tile coordinates[br]
## [param travel_data]: Travel parameters that affect pathfinding[br]
## [b]Returns:[/b] Array of tile coordinates representing the path from start to end (excluding start)
func find_path(start: Vector2i, end: Vector2i, travel_data: TravelData) -> Array[Vector2i]:
	if start == end: 
		return []
	
	if not _are_tiles_valid(start, end, travel_data):
		return []
	
	var current_node := PathNode.new(start, terrain_layer)
	current_node.terrain_cost = 0
	var closed_set: Dictionary[Vector2i, PathNode] = {}  # Tiles that have been evaluated
	var open_set: Dictionary[Vector2i, PathNode] = {}    # Tiles to be evaluated
	const MAX_ITERATIONS = 1000
	
	# A* algorithm main loop, capped at MAX_ITERATIONS
	for iteration in range(MAX_ITERATIONS):
		#_visualize_current_tile(current_node.tile_coords)
		#await get_tree().create_timer(0.1).timeout
		
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
	
	if start_cost < 0 or end_cost < 0:
		return false
	
	return true

func _evaluate_repeating_neighbor(
	neighbor_coords: Vector2i,
	current_node: PathNode, 
	closed_set: Dictionary, 
	travel_data: TravelData
) -> void:
	if closed_set[neighbor_coords].came_from.accumulated_cost > \
	current_node.accumulated_cost:
		closed_set[neighbor_coords].came_from = current_node
		closed_set[neighbor_coords].accumulated_cost = \
			current_node.accumulated_cost + \
			closed_set[neighbor_coords].terrain_cost

func _evaluate_neighbors(
	current_node: PathNode,
	open_set: Dictionary,
	closed_set: Dictionary,
	travel_data: TravelData
) -> void:
	for neighbor_coords in map.get_neighbors(current_node.tile_coords):
		if neighbor_coords in closed_set:
			if not closed_set[neighbor_coords].came_from: 
				continue
			_evaluate_repeating_neighbor(
				neighbor_coords,
				current_node,
				closed_set,
				travel_data,
			)
		else:
			if neighbor_coords in open_set:
				continue
			
			var neighbor_data := terrain_layer.\
				get_cell_tile_data(neighbor_coords)
			if not neighbor_data: continue
			var neighbor_cost: int = neighbor_data.\
				get_custom_data("traverse_cost")
			if neighbor_cost < 0:
				continue
			
			open_set[neighbor_coords] = \
				PathNode.new(neighbor_coords, terrain_layer, current_node)


func _reconstruct_path(end_node: PathNode, start_coords: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var current_node := end_node
	
	while current_node.tile_coords != start_coords:
		path.append(current_node.tile_coords)
		current_node = current_node.came_from
	
	path.reverse()
	return path

# Heuristic function for A* (estimated cost from current position to goal)
func _heuristic(current_pos: Vector2i, goal_pos: Vector2i) -> int:
	return map.get_distance(current_pos, goal_pos)

# Finds the next node to evaluate from the open set using A* scoring
func _get_next_node(open_set: Dictionary[Vector2i, PathNode], goal: Vector2i) -> PathNode:
	if not open_set: 
		return null 
	
	var best_node_coords := Vector2i.ZERO
	var min_score: int
	var is_first := true
	
	for coords in open_set:
		var node := open_set[coords]
		if node.came_from:
			node.accumulated_cost = node.came_from.accumulated_cost + node.terrain_cost
		var score := node.accumulated_cost + _heuristic(node.tile_coords, goal)
		
		if is_first or score < min_score:
			min_score = score
			best_node_coords = coords
			is_first = false
	
	var result := open_set[best_node_coords]
	open_set.erase(best_node_coords)
	return result

func _visualize_current_tile(tile_coords: Vector2i) -> void:
	terrain_layer.set_cell(tile_coords, 2, Vector2i(randi() % 6, randi() % 6))
