class_name PathFinder
extends Node

@onready var map: Map = $".."

## Maximum tile distance permitted for pathfinding calculations.
## If the requested distance exceeds this value, the algorithm will not execute
## and an empty path will be returned.
const MAX_DISTANCE = 50

var terrain_layer: TileMapLayer:
	get:
		return map.terrain_layer

## Represents a node in the A* pathfinding algorithm
class PathNode extends RefCounted:
	var tile_coords: Vector2i
	var came_from: PathNode
	var terrain_cost: int
	var accumulated_cost: int
	
	func _init(
		coords: Vector2i,
		terrain_layer: TileMapLayer,
		travel_data: TravelData,
		from: PathNode = null
	) -> void:
		var tile_data := terrain_layer.get_cell_tile_data(coords)
		terrain_cost = travel_data.get_cost(tile_data)
		tile_coords = coords
		came_from = from
		
		if came_from:
			accumulated_cost = absi(terrain_cost) + came_from.accumulated_cost
		else:
			accumulated_cost = absi(terrain_cost)

func _check_distances(start: Vector2i, end: Array[Vector2i]) -> bool:
	for t in end:
		if map.get_distance(start, t) < MAX_DISTANCE:
			return true
	return false

## Finds a path from start to end using A* algorithm [br][br]
## [param start]: Starting tile coordinates[br]
## [param end]: Array of destination tile coordinates. Algorithm will find a path to
## one of the provided coordinates.[br]
## [param travel_data]: Travel parameters that affect pathfinding[br][br]
## [b]Returns:[/b] Array of tile coordinates representing the path from start
## to end (excluding start)
func A_star(start: Vector2i, end: Array[Vector2i], travel_data: TravelData) -> Array[Vector2i]:
	if start in end: 
		return []
	
	if not _are_tiles_valid(start, end, travel_data):
		return []
	
	if not _check_distances(start, end): return []
	
	var current_node := PathNode.new(start, terrain_layer, travel_data)
	current_node.terrain_cost = 0
	var closed_set: Dictionary[Vector2i, PathNode] = {}  # Tiles that have been evaluated
	var open_set: Dictionary[Vector2i, PathNode] = {}    # Tiles to be evaluated
	
	var goal := start
	
	# A* algorithm main loop, capped at MAX_ITERATIONS
	const MAX_ITERATIONS = 1000
	for iteration in range(MAX_ITERATIONS):
		#_visualize_current_tile(current_node.tile_coords)
		#await get_tree().create_timer(0.1).timeout
		
		# Evaluate all neighbors of the current tile
		_evaluate_neighbors(current_node, open_set, closed_set, travel_data, end)
		
		closed_set[current_node.tile_coords] = current_node
		
		# Check if we reached the destination
		if current_node.tile_coords in end:
			goal = current_node.tile_coords
			break
		
		var next_node := _get_next_node(open_set, end)
		if next_node:
			current_node = next_node
		else:
			break  # No more nodes to evaluate
	
	if goal == start or not closed_set.has(goal):
		return []
	
	return _reconstruct_path(closed_set[goal], start)

func _is_tile_safe(tile: Vector2i, travel_data: TravelData) -> bool:
	if not travel_data.travelling_party:
		return true
	var interception := map.get_first_interception(tile, travel_data.travelling_party)
	return interception == null

func is_passable(tile: Vector2i, travel_data: TravelData, end: Array[Vector2i]) -> bool:
	var data := terrain_layer.get_cell_tile_data(tile)
	if not data: return false
	if data.get_custom_data("traverse_cost") < 0: return false
	for obj in map.get_objects_on_tile(tile):
		if not obj.passable(travel_data): return false
	if travel_data.safe_travel and tile not in end:
		if not _is_tile_safe(tile, travel_data):
			return false
	return travel_data.can_traverse(data)

func _are_tiles_valid(start: Vector2i, end: Array[Vector2i], travel_data: TravelData) -> bool:
	for t in end:
		if is_passable(t, travel_data, end): return true
	return false

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
	travel_data: TravelData,
	end: Array[Vector2i]
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
			
			if not is_passable(neighbor_coords, travel_data, end): continue
			
			open_set[neighbor_coords] = \
				PathNode.new(neighbor_coords, terrain_layer, travel_data, current_node)


func _reconstruct_path(end_node: PathNode, start_coords: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var current_node := end_node
	
	while current_node.tile_coords != start_coords:
		path.append(current_node.tile_coords)
		current_node = current_node.came_from
	
	path.reverse()
	return path

# Heuristic function for A* (estimated cost from current position to goal)
func _heuristic(current_pos: Vector2i, end: Array[Vector2i]) -> int:
	var res := -1
	for t in end:
		var distance := map.get_distance(current_pos, t)
		if res < 0 or distance < res: res = distance
	return res

# Finds the next node to evaluate from the open set using A* scoring
func _get_next_node(open_set: Dictionary[Vector2i, PathNode], end: Array[Vector2i]) -> PathNode:
	if not open_set: 
		return null 
	
	var best_node_coords := Vector2i.ZERO
	var min_score: int
	var is_first := true
	
	for coords in open_set:
		var node := open_set[coords]
		if node.came_from:
			node.accumulated_cost = node.came_from.accumulated_cost + node.terrain_cost
		var score := node.accumulated_cost + _heuristic(node.tile_coords, end)
		
		if is_first or score < min_score:
			min_score = score
			best_node_coords = coords
			is_first = false
	
	var result := open_set[best_node_coords]
	open_set.erase(best_node_coords)
	return result

func _visualize_current_tile(tile_coords: Vector2i) -> void:
	map.event_handler.highlight_tiles([tile_coords])
