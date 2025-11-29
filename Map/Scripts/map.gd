class_name Map
extends Node2D

## Map node. Handles map related actions.
##
## The game uses axial coordinates for hex grid implementation (see tutorial below).
## While theoretically compatible with other grid types, only axial coordinates
## have been tested. [br][br]
##
## To maintain flexibility for potential future grid systems, all methods with
## axial coordinate dependencies are explicitly documented. Switching to an
## alternative grid implementation would require reimplementing only these
## specific functions rather than the entire map system. [br][br]
##
## Current implementation assumes [i]Stairs[/i] or [i]Diamond[/i] layout
## configurations in Godot's [TileMapLayer]. [br][br]
##
## The map is split into three main parts: terrain layer, object layer and objects.
## 
## @tutorial(Hexagonal Grids): https://www.redblobgames.com/grids/hexagons/

## This layer should contain [code]traverse_cost[/code] custom
## data layer with [b]int[/b] type (value of -1 means the tile is not traversable)
@onready var terrain_layer : TileMapLayer = %TerrainLayer
## Layer containing map objects like parties, interactables, etc.
@onready var objects_layer : TileMapLayer = %ObjectsLayer
## Layer used for highlighting tiles during pathfinding and interactions
@onready var highlight_layer: TileMapLayer = %HighlightLayer

## Camera controller for the map
@onready var camera: MapCamera = $Camera2D
## Pathfinding system for calculating routes between tiles
@onready var path_finder: PathFinder = $PathFinder
## Handles user input and map events
@onready var event_handler: MapEventHandler = $EventHandler

## Currently selected party that the player controls
var active_party: MapParty
## Faction that currently has turn control
var active_faction: MapFaction

## Reference to the battle scene to instantiate when combat starts
@export var battle_scene: PackedScene

## Minimum tile coordinate of the map bounds
var min_tile := Vector2i.ZERO
## Maximum tile coordinate of the map bounds  
var max_tile := Vector2i.ZERO


## Returns the file path to the controller scene based on controller type
func get_controller(type: GlobalDefs.ControllerType) -> String:
	match type:
		GlobalDefs.ControllerType.Human:
			return "res://Combat/Scenes/player_controller.tscn"
		GlobalDefs.ControllerType.BasicAI:
			return "res://Combat/Scenes/basic_combat_ai.tscn"
		GlobalDefs.ControllerType.StandardAI:
			return "res://Combat/Scenes/standard_combat_ai.tscn"
	push_error("Unknown Controller type!")
	return ""


## Initiates a battle between two parties. [br]
## [param attacker]: The party initiating the combat encounter[br]
## [param defender]: The party being attacked
func start_battle(attacker: MapParty, defender: MapParty) -> void:
	EventBus.left_units = attacker.units
	EventBus.right_units = defender.units
	EventBus.left_controller = load(get_controller(attacker.faction.controller))
	EventBus.right_controller = load(get_controller(defender.faction.controller))
	
	var battle := battle_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	battle.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_DISABLED
	
	# combat starts here because this is when combat scene enters
	# the tree and _ready() is called
	add_child(battle)
	(battle.find_child("Camera2D", false) as Camera2D).make_current()
	
	await EventBus.battle_ended
	battle.queue_free()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	camera.make_current()


## Returns the global coordinates for the specified tile (coordinates of the center)
func get_global_coords(tile_coord: Vector2i) -> Vector2:
	return terrain_layer.to_global(terrain_layer.map_to_local(tile_coord))


## Returns the distance between two hex positions in axial coordinates. [br]
## Note: This function assumes axial coordinate system
## (Godot's [i]Stairs[/i] or [i]Diamond[/i] layouts)
## and will not produce correct results with offset coordinates
## (Godot's [i]Stacked[/i] layouts)
func get_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	var diff: Vector2i = pos1 - pos2
	var dz := absi(diff.x + diff.y)
	diff = diff.abs()
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

## Sets the active party
func set_active_party(party: MapParty) -> void:
	active_party = party

## Finds a path from [param start] to [param end] for a given [param party]. [br]
## If [param party] is not provided, uses [member active_party].
## [b]Returns[/b]: Array of tile coordinates representing the path, empty if no path found
func find_path(start: Vector2i, end: Vector2i, party: MapParty = null) -> Array[Vector2i]:
	if not party: party = active_party
	if not active_party: return []
	#TODO: construct TravelData object from Party provided
	return path_finder.A_star(start, end, TravelData.new())


## Returns all interactable objects on a specific tile
func get_objects_on_tile(coords: Vector2i) -> Array[MapInteractableObject]:
	var res: Array[MapInteractableObject] = []
	# TODO: introduce two dictionaries to map objects to coordinates
	for c in $Parties.get_children():
		if c is MapParty:
			if c.tile_position == coords:
				res.append(c)
	return res


## Returns the first object on a specific tile that the provided [param party]
## can interact with
func get_first_interactable_object(
	coords: Vector2i,
	party: MapParty = null
) -> MapInteractableObject:
	if not party: party = active_party
	# TODO: introduce two dictionaries to map objects to coordinates
	for c in $Parties.get_children():
		if c is MapParty:
			if c.tile_position == coords:
				return c
	return null


## Returns the bounding coordinates of the circumscribed rectangle containing the entire map.
## For square or offset hex maps this is a rectangle;
## for isometric or axial hex maps it's a rhombus. [br][br]
## [b]Note:[/b] Assumes tile (0, 0) is always included.
## Maps spanning only negative or positive coordinates
## will be expanded to include (0, 0).
## [codeblock]
## var size := get_map_size(map_layer)
## var min_tile := size[0]  # Minimum coordinates
## var max_tile := size[1]  # Maximum coordinates
## [/codeblock]
func get_map_size(layer: TileMapLayer) -> Array[Vector2i]:
	if not layer: return []
	var _min := Vector2i.ZERO
	var _max := Vector2i.ZERO
	for c in layer.get_used_cells():
		if c.x < _min.x: _min.x = c.x
		if c.y < _min.y: _min.y = c.y
		if c.x > _max.x: _max.x = c.x
		if c.y > _max.y: _max.y = c.y
	return [_min, _max]

func _initialize() -> void:
	var size := get_map_size(terrain_layer)
	min_tile = size[0]
	max_tile = size[1]

func _ready() -> void:
	_initialize()
	active_faction = $Factions/Empire
	var map_party_1: MapParty = $Parties/MapParty
	map_party_1.map = self
	map_party_1.walk_to(Vector2i(23, 16))
	
	var map_party_2: MapParty = $Parties/MapParty2
	map_party_2.map = self
	map_party_2.walk_to(Vector2i(26, 10))

## Determines interaction for the active party at the specified [param coordinates]
## and calls performs that action
func request_active_party_interaction(coordinates: Vector2i) -> void:
	if not active_party: return
	var obj := get_first_interactable_object(coordinates)
	if not obj:
		await active_party.walk_along_path(event_handler.get_highlighted_tiles())
		event_handler._reset_highlights()
		return
	await active_party.walk_along_path(event_handler.get_highlighted_tiles())
	event_handler._reset_highlights()
	if obj.request_interaction(active_party): obj.interact(active_party)

## Handles player interaction when no active party is selected
func request_player_interaction(coords: Vector2i) -> void:
	var obj := get_first_interactable_object(coords)
	if obj is MapParty:
		set_active_party(obj)
		return

# Checks if a party can move given the objects in its path
# [param party]: The party attempting to move
# [param objects]: Array of objects at the destination tile
# [return]: true if the party can move, false otherwise
#func can_move(party: MapParty, objects: Array[MapInteractableObject]) -> bool:
	#if not party: return false
	#if party._is_moving: return false
	#if not objects: return true
	#for o in objects:
		#if not o.passable(party): return false
		#if o.request_interaction(party): continue
		#return false
	#return true
