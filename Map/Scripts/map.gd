class_name Map
extends Node2D

## Map node. Handles map related actions.
##
## [br][br][br]
##
## The map consists of three primary components: [b]terrain layer[/b],
## [b]object layer[/b], and [b]interactive objects[/b].[br][br]
##
## [member terrain_layer] serves as the foundational map layer,
## providing essential terrain data including: [br]
## - Terrain types (land, water, mountains, etc.) [br]
## - Movement costs and traversability [br]
## - Tile ownership and claim status [br] [br]
## This layer acts as the spatial reference for all map systems.[br][br]
##
## [member objects_layer] contains static, non-movable objects represented as tiles: [br]
## - Cities, merchant outposts, training facilities [br]
## - Each tile accommodates only one object [br]
## All objects on this layer are tiles and thus it's not possible
## to have two objects on the same tile. [br][br]
##
## [b]Interactive objects[/b] are [MapInteractableObject] nodes that offer dynamic
## map interactions: movement
## [br]
## [br]
## [center]--------------------------------------------------------[/center]
## [br]
## [i]
## The game uses axial coordinates for hex grid implementation (see tutorial below).
## While theoretically compatible with other grid types, only axial coordinates
## have been tested. [br][br]
## @tutorial(Hexagonal Grids): https://www.redblobgames.com/grids/hexagons/
##
## To maintain flexibility for potential future grid systems, all methods with
## axial coordinate dependencies are explicitly documented. Switching to an
## alternative grid implementation would require reimplementing only these
## specific functions rather than the entire map system. [br][br]
##
## Current implementation assumes [u]Stairs[/u] or [u]Diamond[/u] layout
## configurations in Godot's [TileMapLayer].
## [/i]

## This layer should contain [code]traverse_cost[/code] custom
## data layer with [b]int[/b] type (value of -1 means the tile is not traversable)
@onready var terrain_layer : TileMapLayer = %TerrainLayer
## Layer containing map objects like parties, interactables, etc.
@onready var objects_layer : MapObjectsLayer = %ObjectsLayer
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

## Mapping between tile coordinates and objects on the map
## Should be:
## [codeblock]
## Dictionary[ Vector2i, Array[MapInteractableObject] ]
## [/codeblock]
## But nested typed collections are not supported in Godot
var tile_to_object: Dictionary[Vector2i, Array] = {}

func clean_hashtable() -> void:
	for k: Vector2i in tile_to_object.keys():
		if not tile_to_object[k]:
			tile_to_object.erase(k)

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

## Safely removes the object and clears any references preserved by the map. [br][br]
## Use this method as a last resort only, since [MapInteractableObject] instances
## are generally not designed to be freed during runtime.
## See class documentation for alternatives.
func free_map_object(o: MapInteractableObject) -> void:
	clear_object_refs(o)
	o.queue_free()

func clear_object_refs(o: MapInteractableObject) -> void:
	if not is_instance_valid(o):
		push_error("Invalid reference passed to clear object! Did you free it somewhere else?")
		return
	tile_to_object.get(o.tile_position, []).erase(o)

func _prefill_data(attacker: MapParty, defender: MapParty) -> void:
	EventBus.left_units = attacker.units
	EventBus.right_units = defender.units
	EventBus.left_controller = load(get_controller(attacker.faction.controller))
	EventBus.right_controller = load(get_controller(defender.faction.controller))

func _load_battle(attacker: MapParty, defender: MapParty) -> Node:
	var battle: Control = battle_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	battle.process_mode = Node.PROCESS_MODE_ALWAYS
	battle.hide()
	
	# combat starts here because this is when combat scene enters
	# the tree and _ready() is called
	add_sibling(battle)
	return battle

const battle_effect = preload("res://Map/Scenes/visual_effect.tscn")

func _switch_to_battle(battle: Control) -> void:
	(battle.find_child("Camera2D", false) as Camera2D).make_current()
	
	battle.show()
	process_mode = Node.PROCESS_MODE_DISABLED
	set_process(false)
	
	await EventBus.battle_ended
	set_process(true)
	battle.queue_free()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	camera.make_current()

func _play_effect(pos: Vector2) -> void:
	var effect := battle_effect.instantiate() as TemporaryEffect
	add_child(effect)
	effect.global_position = pos
	await effect.effect_finished

## Initiates a battle between two parties. [br]
## [param attacker]: The party initiating the combat encounter[br]
## [param defender]: The party being attacked
func start_battle(attacker: MapParty, defender: MapParty) -> void:
	_prefill_data(attacker, defender)
	
	var battle := _load_battle(attacker, defender)
	await _play_effect(defender.global_position)
	
	await _switch_to_battle(battle)
	attacker.update_parameters()
	defender.update_parameters()

## Returns the global coordinates for the specified tile (coordinates of the center)
func get_global_coords(tile_coord: Vector2i) -> Vector2:
	return terrain_layer.to_global(terrain_layer.map_to_local(tile_coord))

## Returns the distance between two hex positions in axial coordinates. [br]
## [b]Note:[/b] This function assumes axial coordinate system
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
	return terrain_layer.get_surrounding_cells(coords)

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
	res.assign(tile_to_object.get(coords, []))
	return res

## Returns the first object on a specific tile that the
## provided [param party] can interact with.
## If no party is providedm uses [member active_party] [br][br]
## [i]See also: [method get_interactable_object_no_filter] [/i]
func get_first_interactable_object(
	coords: Vector2i,
	party: MapParty = null
) -> MapInteractableObject:
	if not party: party = active_party
	var objects := get_objects_on_tile(coords)
	for o in objects:
		if o.request_interaction(party): return o
	return null

## Returns the first object on a specific tile.[br][br]
## [i]See also: [method get_first_interactable_object] [/i]
func get_interactable_object_no_filter(
	coords: Vector2i
) -> MapInteractableObject:
	var objects := get_objects_on_tile(coords)
	return objects[0] if objects else null


## Returns the bounding coordinates of the circumscribed rectangle containing
## the entire map. [br]
## For square or offset hex maps this is a rectangle;
## for isometric or axial hex maps it's a rhombus. [br][br]
## [b]Note:[/b] Assumes tile (0, 0) is always included.
## Maps spanning only negative or positive coordinates
## will be expanded to include (0, 0).[br]
## The returned array has the structure [code][min, max][/code]:
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

func _check_object_layer() -> void:
	for c in objects_layer.get_used_cells():
		if c.x < min_tile.x or \
			c.x > max_tile.x:
				push_error("Object layer is bigger than terrain layer!
	object at: " + str(c) + "; map size: " + str(min_tile) + "-" + str(max_tile))

func _initialize() -> void:
	var size := get_map_size(terrain_layer)
	min_tile = size[0]
	max_tile = size[1]
	
	_check_object_layer()
	objects_layer.map = self

func test() -> void:
	objects_layer.set_tile(Vector2i(30, 20))

func _ready() -> void:
	_initialize()
	
	active_faction = $Factions/Empire
	test.call_deferred()

func _move_active_party(coords: Vector2i) -> void:
	if active_party.is_moving:
		active_party.abort_moving()
		return
	await active_party.control.walk_along_path(event_handler.get_highlighted_tiles())
	event_handler._reset_highlights()

## Determines interaction for the active party at the specified
## [param coordinates] and performs that action
func request_active_party_interaction(coordinates: Vector2i) -> void:
	if not active_party: return
	await _move_active_party(coordinates)

## Handles player interaction when no active party is selected
func request_player_interaction(coords: Vector2i) -> void:
	var objects := get_objects_on_tile(coords)
	for obj in objects:
		if obj.request_player_interaction(active_faction):
			obj.player_interact(active_faction)
			return

## Checks if a party can move to the given [param tile]
func can_move(party: MapParty, tile: Vector2i) -> bool:
	if not party: return false
	if party.is_moving: return false
	var objects := get_objects_on_tile(tile)
	if not objects: return true
	for o in objects:
		if not o.passable(party): return false
	return true
