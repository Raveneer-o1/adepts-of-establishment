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
		_map: Map,
		travel_data: TravelData,
		from: PathNode = null
	) -> void:
		var tile_data := _map.get_tile_data(coords)
		terrain_cost = travel_data.get_cost(tile_data)
		tile_coords = coords
		came_from = from
		
		if came_from:
			accumulated_cost = absi(terrain_cost) + came_from.accumulated_cost
		else:
			accumulated_cost = absi(terrain_cost)

func _check_distances(start: Vector2i, end: Array[Vector2i]) -> bool:
	for t in end:
		if Map.get_distance(start, t) < MAX_DISTANCE:
			return true
	return false

## Finds a path from start to end using A* algorithm [br][br]
## [param start]: Starting tile coordinates[br]
## [param end]: Array of destination tile coordinates. Algorithm will find a path to
## one of the provided coordinates.[br]
## [param travel_data]: Travel parameters that affect pathfinding[br][br]
## [b]Returns:[/b] Array of tile coordinates representing the path from start
## to end (excluding start)
func A_star(
	start: Vector2i,
	end: Array[Vector2i],
	travel_data: TravelData,
	consider_visibility: bool
) -> Array[Vector2i]:
	if start in end: 
		return [] as Array[Vector2i]
	
	if not _are_tiles_valid(start, end, travel_data, consider_visibility):
		return [] as Array[Vector2i]
	
	if not _check_distances(start, end): return [] as Array[Vector2i]
	
	var current_node := PathNode.new(start, map, travel_data)
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
		_evaluate_neighbors(
			current_node,
			open_set,
			closed_set,
			travel_data,
			end,
			consider_visibility
		)
		
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
		return [] as Array[Vector2i]
	
	return _reconstruct_path(closed_set[goal], start)

func _is_tile_safe(tile: Vector2i, travel_data: TravelData) -> bool:
	if not travel_data.travelling_party:
		return true
	var interception := map.get_first_interception(tile, travel_data.travelling_party)
	return interception == null

## Returns whether the specified [param tile] is passable for the given [param travel_data].
## The [param end] array allows destination tiles to be excluded from interruption checks
## (can be left empty if not needed). When [param consider_visibility] is [code]true[/code],
## tiles hidden under fog of war are treated as impassable.
func is_passable(
	tile: Vector2i,
	travel_data: TravelData,
	end: Array[Vector2i],
	consider_visibility: bool
) -> bool:
	if consider_visibility and travel_data.travelling_party:
		if not map.get_tile_data(tile): return false
		if map.get_tile_data(tile).is_under_fog_of_war(travel_data.travelling_party.object_owner):
			return false
	var data := map.get_tile_data(tile)
	if not data: return false
	if data.get_traverse_cost() < 0: return false
	for obj: MapInteractableObject in map.tile_to_object.get(tile, []):
		if not obj.is_active: continue
		if not obj.passable(travel_data): return false
	if travel_data.safe_travel and tile not in end:
		if not _is_tile_safe(tile, travel_data):
			return false
	return travel_data.can_traverse(data.tile_data)

func _are_tiles_valid(
	start: Vector2i,
	end: Array[Vector2i],
	travel_data: TravelData,
	consider_visibility: bool
) -> bool:
	for t in end:
		if is_passable(t, travel_data, end, consider_visibility): return true
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
	end: Array[Vector2i],
	consider_visibility: bool
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
			
			if not is_passable(neighbor_coords, travel_data, end, consider_visibility): continue
			
			open_set[neighbor_coords] = \
				PathNode.new(neighbor_coords, map, travel_data, current_node)


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
		var distance := Map.get_distance(current_pos, t)
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


## Returns all tiles within the specified [param radius] of the given [param center].
## If [param for_traveller] is provided, the result is filtered to tiles reachable
## within [param radius] steps by that traveller.
## Otherwise, includes all tiles regardless of passability.[br][br]
## When [param padding] is greater than zero, the original area is expanded outward
## by that many tiles in all directions, without any passability checks.
## This is useful for determining visibility ranges that should cover obstacles
## themselves, not just traversable tiles. [br][br]
## If [param use_visibility_check] is [code]true[/code], instead of passable
## tiles includes transparent tiles (see [method MapTileData.get_transparency]
## and [enum TravelData.Visibility_ID]). Has no effect if [param for_traveller]
## is [code]null[/code].
func get_all_tiles(
	center: Vector2i,
	radius: int,
	for_traveller: TravelData = null,
	padding := 0,
	use_visibility_check := false
) -> Array[Vector2i]:
	var center_tile: MapTileData = _get_center_tile(center)
	if not center_tile:
		return []
	
	var open_set: Dictionary[MapTileData, int] = {center_tile: 0}
	var closed_set: Dictionary[MapTileData, int] = {center_tile: 0}
	var result: Array[Vector2i] = [center]
	
	while open_set:
		var current_tile: MapTileData = open_set.keys().front()
		var current_cost := open_set[current_tile]
		open_set.erase(current_tile)
		
		if not _make_check(current_tile, for_traveller, use_visibility_check):
			current_cost = maxi(current_cost, radius)
			#continue
		
		_process_tile(current_tile, current_cost, radius + padding, closed_set, result)
		_expand_neighbors(current_tile, current_cost, radius + padding, open_set)
	
	return result

func _make_check(
	tile: MapTileData,
	traveller: TravelData,
	use_visibility_check: bool
) -> bool:
	# null traveller means we need to include all cells in a radius
	if not traveller: return true
	
	if use_visibility_check: return traveller.can_see_through(tile)
	return traveller.can_traverse(tile.tile_data)

func _get_center_tile(center: Vector2i) -> MapTileData:
	return map.tile_data_hashmap.get(center)

func _process_tile(
	tile: MapTileData,
	cost: int,
	radius: int,
	closed_set: Dictionary,
	result: Array[Vector2i],
) -> void:
	if cost <= radius and tile not in closed_set:
		result.append(tile.coordinates)
		closed_set[tile] = cost

func _expand_neighbors(
	tile: MapTileData,
	current_cost: int,
	radius: int,
	open_set: Dictionary[MapTileData, int],
) -> void:
	var next_cost := current_cost + 1
	if next_cost >= radius:
		return
	
	for neighbor in tile.get_neighbors():
		open_set[neighbor] = mini(next_cost, open_set.get(neighbor, next_cost))
