class_name Map
extends Node2D

## Map node. Handles map related actions.
##
## The map consists of three primary components: [b]terrain layer[/b],
## [b]object layer[/b], and [b]interactive objects[/b].[br][br]
##
## [member terrain_layer] serves as the foundational map layer,
## providing essential terrain data including: [br]
## - Terrain types (land, water, mountains, etc.) [br]
## - Movement costs and traversability [br]
## - Tile ownership and claim status [br]
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
## Current implementation assumes [u]Stairs Right[/u] layout
## configurations in Godot's [TileMapLayer].
## [/i]

## This layer should contain [code]traverse_cost[/code] custom
## data layer with [b]int[/b] type (value of -1 means the tile is not traversable)
@onready var terrain_layer: TileMapLayer = $MapLayers/TerrainLayer
## Layer containing map immovable objects like cities, mines, etc.
## [br][br]
## Note: In the current development workflow, this layer will often be empty
## because we're editing maps directly in Godot's editor. Tile-bound objects
## that would normally be placed here are instead treated as "free" objects
## managed by the [member object_manager] for easier in-editor manipulation.
@onready var objects_layer: MapObjectsLayer = $MapLayers/ObjectsLayer
## Layer that determines ares - sets of tiles used for the event system.
@onready var zones_layer: ZonesLayer = $MapLayers/ZonesLayer
@onready var fog_of_war_layer: TileMapLayer = $MapLayers/FogOfWarLayer

## Handles "free" objects - objects that are not part of the [member objects_layer].
## [Party] objects are not managed by this node: they are managed separately. [br][br]
## 
## For the time being, most tile-bound objects are treated as "free"
## objects and managed here rather than in [member objects_layer].
## This allows to edit maps directly in Godot's editor without
## implementing a separate map editor. 
@onready var object_manager: MapObjectManager = $ObjectManager

## Layer used for highlighting tiles during pathfinding and interactions
@onready var highlight_layer: TileMapLayer = $MapLayers/HighlightLayer

## Pathfinding system for calculating routes between tiles
@onready var path_finder: PathFinder = $PathFinder
## Handles user input and map events
@onready var event_handler: MapEventHandler = $EventHandler
## Handles the actual execution of map operations that serve as API endpoints.
@onready var worker: MapWorker = $Worker
## Shows the information (like highlights) to the player
@onready var visualizer: MapVisualizer = $Visualizer

@onready var camera: StrategyCamera = $StrategyCamera

@onready var parties_container: Node = $Parties

## [i][img width=24]res://icons/Raveneer-o1.png[/img] 27.12.2025:[/i][br]
## 40x42 map [i](1680 tiles)[/i] uses 2.4 MiB of memory.
## Not a big deal right now but may be a bottleneck for scalability
var tile_data_hashmap: Dictionary[Vector2i, MapTileData]

var game: GameMap

## Currently selected party that the player controls
var active_party: MapParty:
	get: return active_party
	set(value):
		active_party = value
		game.update_active_party(value)

## Faction that currently has turn control
var active_faction: MapFaction:
	get: return game.turn_manager.active_faction
	set(value): game.turn_manager.active_faction = value

## Reference to the battle scene prefab to instantiate when combat starts
@export var battle_scene: PackedScene

## Minimum tile coordinate of the map bounds
var min_tile := Vector2i.ZERO
## Maximum tile coordinate of the map bounds  
var max_tile := Vector2i.ZERO

## Mapping between tile coordinates and objects on the map. [br][br]
## Should be:
## [codeblock]
## Dictionary[ Vector2i, Array[MapInteractableObject] ]
## [/codeblock]
## But nested typed collections are not supported in Godot
var tile_to_object: Dictionary[Vector2i, Array] = {}

## @experimental: this may consume too much memory
## Mapping between interaction points and interactable objects on the map. [br][br]
## Should be:
## [codeblock]
## Dictionary[ Vector2i, Array[MapInteractableObject] ]
## [/codeblock]
## But nested typed collections are not supported in Godot
var tile_to_interaction: Dictionary[Vector2i, Array] = {}

var __now_cleaning: bool = false
## Removes empty entries from internal hashtables. If [param assume_iteration] is provided,
## reduces first-frame processing by the specified amount. Values over [code]500[/code]
## skip first-frame processing entirely.[br]
## Use this when heavy calculations have already occurred in the current frame
## to maintain target frame rate.
func clean_hashtable(assume_iteration: int = 0) -> void:
	# The plan is to add support for somewhat unlimited number of objects on the map
	# so we have to consider large hashmaps with thousands entries
	if __now_cleaning: return
	__now_cleaning = true
	
	# NOTE: this value is chosen arbitrarily
	#       ideally, it should be calculated from hardware specs
	const MAX_ITERATIONS_PER_FRAME = 500
	var i := assume_iteration
	for k: Vector2i in tile_to_object.keys():
		i += 1
		if i >= MAX_ITERATIONS_PER_FRAME:
			# if already processing too much entries, wait for next frame
			await get_tree().process_frame
			i = 0
		if not tile_to_object[k]:
			tile_to_object.erase(k)
	
	for k: Vector2i in tile_to_interaction.keys():
		i += 1
		if i >= MAX_ITERATIONS_PER_FRAME:
			await get_tree().process_frame
			i = 0
		if not tile_to_interaction[k]:
			tile_to_interaction.erase(k)
	
	__now_cleaning = false

func get_all_parties() -> Array[MapParty]:
	var res: Array[MapParty] = []
	res.assign(parties_container.get_children())
	return res

## Safely removes the object and clears any references preserved by the map. [br][br]
## Use this method as a last resort only, since [MapInteractableObject] instances
## are generally not designed to be freed during runtime.
## See class documentation for alternatives.
func free_map_object(o: MapInteractableObject) -> void:
	clear_object_refs(o)
	o.queue_free()

## Clears references stored by the [Map] node to the provided [param object]
func clear_object_refs(object: MapInteractableObject) -> void:
	if not is_instance_valid(object):
		push_error("Invalid reference passed to clear object! Did you free it somewhere else?")
		return
	for t in object.get_occupied_tiles():
		if tile_to_object.has(t):
			tile_to_object[t].erase(object)
	for t in object.get_interaction_tiles():
		if tile_to_interaction.has(t):
			tile_to_interaction[t].erase(object)

func start_siege(attacker: MapParty, defender: MapCity) -> void:
	var successful := await worker.do_siege(attacker, defender)
	game.update_active_party(active_party)
	if not successful: return
	defender.object_owner = attacker.faction
	attacker.enter_city(defender)

## Initiates a battle between two parties. [br]
## [param attacker]: The party initiating the combat encounter[br]
## [param defender]: The party being attacked
func start_battle(attacker: MapParty, defender: MapParty) -> void:
	var winner := await worker.do_combat(attacker, defender)
	game.update_active_party(active_party)
	if not winner: return
	var loser := defender if winner == attacker else attacker
	loser.inventory.transfer_all_items(winner.inventory)

## Returns the global coordinates for the specified tile (coordinates of the center)
func get_global_coords(tile_coord: Vector2i) -> Vector2:
	return terrain_layer.to_global(terrain_layer.map_to_local(tile_coord))

## Converts global [param coords] to tile coordinates.
## If nothig is provided, uses current mouse position.
func get_tile_coords(coords: Vector2 = get_global_mouse_position()) -> Vector2i:
	return terrain_layer.local_to_map(terrain_layer.to_local(coords))

## Returns a [MapTileData] object on the specified [param coords].
## If nothig is provided, uses current mouse position.
## If no object exists at the specified coordinates, returns [code]null[/code].
func get_tile_data(coords: Vector2i = get_tile_coords()) -> MapTileData:
	return tile_data_hashmap.get(coords)

## Returns the distance between two hex positions in axial coordinates. [br]
## [b]Note:[/b] This function assumes axial coordinate system
## (Godot's [i]Stairs[/i] or [i]Diamond[/i] layouts)
## and will not produce correct results with offset coordinates
## (Godot's [i]Stacked[/i] layouts)
static func get_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	var diff: Vector2i = pos1 - pos2
	var dz := absi(diff.x + diff.y)
	diff = diff.abs()
	return (diff.x + diff.y + dz) >> 1

## Gets all neighboring tiles for a given coordinate
func get_neighbors(coords: Vector2i) -> Array[Vector2i]:
	return terrain_layer.get_surrounding_cells(coords)

## Sets the active party. Can be set to [code]null[/code] to clear
## active party selection
func set_active_party(party: MapParty) -> void:
	active_party = party
	visualizer.reset_highlights()

## Finds a path from [param start] to [param end] for a given [param party]. [br]
## If [param party] is not provided, uses [member active_party]. [br]
## If [param include_start] is [code]false[/code], the starting tile is excluded
## from both passability checks and the resulting path.[br]
## [b]Returns[/b]: Array of tile coordinates representing the path, empty if no path found
## [br][br]
## [b]Note:[/b] Not optimized for large arrays - expects [param starts]
## and [param ends] to contain not more than 10 elements each.
## For larger search spaces may cause performance spikes.
func find_path(
	starts: Array[Vector2i],
	end: Vector2i,
	party: MapParty = active_party,
	include_start: bool = false
) -> Array[Vector2i]:
	return worker.find_path(
		starts,
		[end],
		party,
		include_start
	)

## Same as [method find_path] but accepts [MapInteractableObject] as the goal.
## The path targets tiles provided by [method MapInteractableObject.get_interaction_tiles].
func find_path_to_object(
	starts: Array[Vector2i],
	end: MapInteractableObject,
	party: MapParty = active_party,
	include_start: bool = false
) -> Array[Vector2i]:
	if not end: return []
	var end_tiles := end.get_interaction_tiles(party)
	for start in starts:
		if start in end_tiles: return []
	return worker.find_path(
		starts,
		end_tiles,
		party,
		include_start
	)

## Returns all objects that have the specified [param coords] as an interaction tile,
## sorted by [member MapInteractableObject.interaction_priority].
## Inactive objects are excluded (see [member MapInteractableObject.is_active]). [br][br]
## [b]Note:[/b] This method can be slow on maps with many overlapping objects.
## For faster, unsorted, untyped access, use:
## [codeblock]
## tile_to_interaction.get(coords, [])
## [/codeblock]
func get_interactions_on_tile(coords: Vector2i) -> Array[MapInteractableObject]:
	var res: Array[MapInteractableObject] = []
	res.assign(tile_to_interaction.get(coords, []))
	for obj: MapInteractableObject in res.duplicate():
		if not obj.is_active: res.erase(obj)
	res.sort_custom(
		func(a: MapInteractableObject, b: MapInteractableObject) -> bool:
			return a.interaction_priority > b.interaction_priority
	)
	
	return res

## Returns all interactable objects on a specific tile,
## sorted by [member MapInteractableObject.interaction_priority].
## Inactive objects are excluded (see [member MapInteractableObject.is_active]). [br][br]
## [b]Note:[/b] This method can be slow on maps with many overlapping objects.
## For faster, unsorted, untyped access, use:
## [codeblock]
## tile_to_object.get(coords, [])
## [/codeblock]
func get_objects_on_tile(coords: Vector2i) -> Array[MapInteractableObject]:
	var res: Array[MapInteractableObject] = []
	res.assign(tile_to_object.get(coords, []))
	for obj: MapInteractableObject in res.duplicate():
		if not obj.is_active: res.erase(obj)
	res.sort_custom(
		func(a: MapInteractableObject, b: MapInteractableObject) -> bool:
			return a.interaction_priority > b.interaction_priority
	)
	return res

## Returns the first object on a specific tile that the
## provided [param party] can interact with. [br][br]
## [i]See also: [method get_interactable_object_no_filter] [/i]
func get_first_interactable_object(
	coords: Vector2i,
	party: MapParty = active_party
) -> MapInteractableObject:
	var objects := get_objects_on_tile(coords)
	for o in objects:
		if not o.can_interact(party): continue
		return o
	return null

## Returns the first object on a specific tile.[br][br]
## [i]See also: [method get_first_interactable_object] [/i]
func get_interactable_object_no_filter(
	coords: Vector2i
) -> MapInteractableObject:
	var objects := get_objects_on_tile(coords)
	for o in objects:
		return o
	return null

## Returns the first object that will intercept provided [param party]
## on the specified [param coords]
func get_first_interception(
	coords: Vector2i,
	party: MapParty = active_party
) -> MapInteractableObject:
	var objects := get_interactions_on_tile(coords)
	for o in objects:
		if o == party: continue
		if not o.will_intercept(party): continue
		return o
	return null

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

func _initialize() -> void:
	var next_parent := get_parent()
	while next_parent and not game:
		if next_parent is GameMap: game = next_parent
		else: next_parent = next_parent.get_parent()
	if not game:
		push_error("Unable to find GameMap!")
		queue_free()
		return
	
	worker.create_tile_data()
	
	var size := get_map_size(terrain_layer)
	min_tile = size[0]
	max_tile = size[1]
	
	worker.check_object_layer()
	objects_layer.map = self
	_fill_for_of_war()
	if not GameSettings.enable_fog_of_war:
		fog_of_war_layer.hide()
	EventBus.map_turn_ended.connect(new_turn)

func _ready() -> void:
	_initialize()

func _fill_for_of_war() -> void:
	var full_rect := \
		terrain_layer.get_used_rect().merge(
			fog_of_war_layer.get_used_rect()
		)
	for i in range(full_rect.position.x, full_rect.end.x):
		for j in range(full_rect.position.y, full_rect.end.y):
			draw_fog_of_war(Vector2i(i, j))

## Updates values for new turn. Does not start the turn,
## this is done through [GameMap] class
func new_turn(f: MapFaction) -> void:
	active_party = null

## Cancels all currently active map actions (e.g., party movement).
## Use with [code]await[/code] to wait for animations to complete before proceeding.
func abort_actions() -> void:
	await worker.abort_active_actions()

## Processes interaction like player's click or AI's select.[br]
## [color=red]Important:[/color] Do [b]not[/b] call this method directly.
## Only interact though [FactionAPI]
func player_act(coords: Vector2i, faction: MapFaction) -> void:
	#print_debug("Got input (%s)" % str(coords))
	
	var objects := get_objects_on_tile(coords)
	var obj_interaction := false
	if faction == game.screen_player:
		for obj in objects:
			if obj.request_player_interaction(faction):
				obj.player_interact(faction)
				obj_interaction = true
				break
	
	#visualizer.reset_highlights()
	#var rad := path_finder.get_all_tiles(
		#coords,
		#3,
		#TravelData.new(active_party) if active_party else null,
		#2
	#)
	#visualizer.highlight_tiles(rad)
	#return
	
	if not active_party: return
	if active_party.is_moving:
		abort_actions()
	if obj_interaction: return
	if active_party.faction != faction: return
	for obj in objects:
		if obj.can_interact(active_party):
			await worker.move_active_party_to_object(obj)
			return
	await worker.move_active_party(coords)
	#print_debug("Input processed")

## @experimental: arguments type and behavior are subjects to change
func claim_tile(tile: MapTileData, faction: MapFaction, power: float) -> bool:
	return worker.do_tile_claim(tile, faction, power)

const _FOG_OF_WAR_ATLAS = 0
## Applies the fog‑of‑war effect to the specified [param tile].[br]
## This method is not intended to be called directly — use
## [method GameMap.update_visibility] instead.
func draw_fog_of_war(tile: Vector2i) -> void:
	if fog_of_war_layer.get_cell_atlas_coords(tile) != Vector2i(-1, -1):
		return
	fog_of_war_layer.set_cell(
		tile,
		_FOG_OF_WAR_ATLAS,
		Vector2i(0, randi_range(0, 2))
	)
## Erases the fog‑of‑war effect from the specified [param tile].[br]
## This method is not intended to be called directly — use
## [method GameMap.update_visibility] instead.
func erase_fog_of_war(tile: Vector2i) -> void:
	fog_of_war_layer.set_cell(
		tile,
	)

## Updates the visibility of the given [param tile] based on the current
## [member GameMap.screen_player]. [br]
## [b]Note:[/b] When [member GameMap.screen_player] changes, the entire map’s fog‑of‑war is
## redrawn automatically; calling this method is not necessary in that case.
func update_visibility(tile: MapTileData) -> void:
	if not tile: return
	if tile.map != self: return
	if tile.is_under_fog_of_war(game.screen_player):
		draw_fog_of_war(tile.coordinates)
	else:
		erase_fog_of_war(tile.coordinates)

func get_all_objects() -> Array[MapInteractableObject]:
	var res: Array[MapInteractableObject]
	
	for c in object_manager.get_children():
		if c is MapInteractableObject: res.append(c)
	
	for c in objects_layer.get_children():
		if c is MapInteractableObject: res.append(c)
	
	for c in parties_container.get_children():
		if c is MapInteractableObject: res.append(c)
	
	return res
