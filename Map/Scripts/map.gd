class_name Map
extends Node2D

## Map node. Handles map related actions.

## This layer should contain [code]traverse_cost[/code] custom
## data layer with [b]int[/b] type (value of -1 means the tile is not traversable)
@onready var terrain_layer : TileMapLayer = %TerrainLayer
@onready var objects_layer : TileMapLayer = %ObjectsLayer
@onready var highlight_layer: TileMapLayer = %HighlightLayer

@onready var camera: MapCamera = $Camera2D
@onready var path_finder: PathFinder = $PathFinder

## Currently selected party that the player controls
var active_party: MapParty
## Faction that currently has turn control
var active_faction: MapFaction

## Reference to the battle scene to instantiate when combat starts
@export var battle_scene: PackedScene

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

func _clear_eventbus() -> void:
	for u in EventBus.left_units + EventBus.right_units:
		if u: u.free()
	EventBus.left_units = []
	EventBus.right_units = []
	#if EventBus.left_controller:
		#EventBus.left_controller.free()
		#EventBus.left_controller = null
	#if EventBus.right_controller:
		#EventBus.right_controller.free()
		#EventBus.right_controller = null

## Initiates a battle between two parties. [br]
## [param attacker]: The party initiating the combat encounter[br]
## [param defender]: The party being attacked
func start_battle(attacker: MapParty, defender: MapParty) -> void:
	_clear_eventbus()
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

## Returns the global coordinates for the specified tile
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

## Finds a path between two points
func find_path(start: Vector2i, end: Vector2i, travel_data: TravelData) -> Array[Vector2i]:
	#TODO: construct TravelData object from Party provided
	return path_finder.A_star(start, end, travel_data)

## Returns all interactable objects on a specific tile
func get_objects_on_tile(coords: Vector2i) -> Array[MapInteractableObject]:
	var res: Array[MapInteractableObject] = []
	for c in $Parties.get_children():
		if c is MapParty:
			if c.tile_position == coords:
				res.append(c)
	return res

func _ready() -> void:
	active_faction = $Factions/Empire
	var map_party_1: MapParty = $Parties/MapParty
	map_party_1.map = self
	map_party_1.walk_to(Vector2i(23, 16))
	
	var map_party_2: MapParty = $Parties/MapParty2
	map_party_2.map = self
	map_party_2.walk_to(Vector2i(26, 10))

func _handle_mouse_hovering() -> void:
	if not active_party: return
	if active_party._is_moving: return
	
	var mouse_coords := terrain_layer.local_to_map(get_local_mouse_position())
	if _last_target_tile == mouse_coords: return
	
	_reset_highlights()
	var tile_data := terrain_layer.get_cell_tile_data(mouse_coords)
	if not tile_data: 
		return
	
	var path := find_path(
		active_party.tile_position,
		mouse_coords,
		TravelData.new()
	)
	_last_target_tile = mouse_coords
	_highlight_tiles(path)
	get_viewport().set_input_as_handled()

func _party_click(party: MapParty) -> void:
	if active_faction == party.faction:
		active_party = party
		return
	if not active_party: return
	if party.request_interaction(active_party):
		var path := find_path(
			active_party.tile_position,
			party.tile_position,
			TravelData.new()
		)
		await active_party.walk_along_path(path)
		party.interact(active_party)

func _process_click() -> void:
	#print("click")
	var tile := terrain_layer.local_to_map(get_local_mouse_position())
	var objs := get_objects_on_tile(tile)
	var target_party: MapParty = null
	for o in objs:
		if o is MapParty:
			target_party = o
			break
	if target_party:
		_party_click(target_party)
		get_viewport().set_input_as_handled()
		return
	if active_party:
		if tile not in _highlighted_tiles: return
		get_viewport().set_input_as_handled()
		await active_party.walk_along_path(_highlighted_tiles)

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	match event.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			_process_click()
		MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom_out()
			get_viewport().set_input_as_handled()
		MouseButton.MOUSE_BUTTON_WHEEL_UP:
			camera.zoom_in()
			get_viewport().set_input_as_handled()

func _handle_camera_key(event: InputEventKey) -> void:
	var key := event.keycode
	var direction := Vector2.ZERO
	match key:
		Key.KEY_D:
			direction += Vector2.RIGHT
		Key.KEY_A:
			direction += Vector2.LEFT
		Key.KEY_S:
			direction += Vector2.DOWN
		Key.KEY_W:
			direction += Vector2.UP
	
	if event.is_released():
		direction = -direction
	camera.start_drift(direction)

func _unhandled_key_input(event: InputEvent) -> void:
	_handle_camera_key(event)
	get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		_handle_mouse_input(event)
		return
	if event is InputEventMouseMotion:
		_handle_mouse_hovering()

var _last_target_tile: Vector2i
var _highlighted_tiles: Array[Vector2i]

func _reset_highlights() -> void:
	for t in _highlighted_tiles:
		highlight_layer.set_cell(t)
	_highlighted_tiles.clear()

# Dictionary mapping color identifiers to atlas coordinates for highlighting
const _ALTERNATIVE_COLOR: Dictionary[StringName, Vector2i] = {
	#"blue" = Vector2i(2, 0),
	"yellow" = Vector2i(1, 0),
}

const _TILE_HIGHLIGHT_ATLAS_ID = 2

func _highlight_tiles(tiles: Array[Vector2i]) -> void:
	for t in tiles:
		var data := terrain_layer.get_cell_tile_data(t)
		var atlas_coords := Vector2i(0, 0)
		if data:
			var color_name: StringName = data.get_custom_data("color_identifier")
			atlas_coords = _ALTERNATIVE_COLOR.get(color_name, atlas_coords)
		highlight_layer.set_cell(t, _TILE_HIGHLIGHT_ATLAS_ID, atlas_coords)
	_highlighted_tiles.append_array(tiles)
