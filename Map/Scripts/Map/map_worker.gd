class_name MapWorker
extends Node

@onready var map: Map = $".."
@onready var visualizer: MapVisualizer = $"../Visualizer"

var active_party: MapParty:
	get: return map.active_party
var event_handler: MapEventHandler:
	get: return map.event_handler
var game: GameMap:
	get: return map.game

const battle_effect = preload("res://Map/Scenes/visual_effect.tscn")

## Returns if siege was successful
func do_siege(attacker: MapParty, defender: MapCity) -> bool:
	_prefill_data_siege(attacker, defender)
	var battle := _load_battle()
	
	var upd := func() -> void:
		attacker.update_parameters()
		defender.update_parameters()
	
	_update_units.connect(upd)
	await _switch_to_battle(battle, attacker.units, defender.units)
	_update_units.disconnect(upd)
	
	# not necessary but in case update is not triggered, this is a safeguard
	upd.call()
	
	var siege_successful := not attacker.is_dead
	if siege_successful:
		for unit in defender.units:
			unit.queue_free()
	return siege_successful

## Processes combat and returns the winner or [code]null[/code] if there isn't one
func do_combat(attacker: MapParty, defender: MapParty) -> MapParty:
	_prefill_data(attacker, defender)
	
	attacker.face_tile(defender.tile_position)
	defender.face_tile(attacker.tile_position)
	
	var battle := _load_battle()
	await _play_effect(defender.global_position)
	
	var upd := func() -> void:
		attacker.update_parameters()
		defender.update_parameters()
	
	_update_units.connect(upd)
	await _switch_to_battle(battle, attacker.units, defender.units)
	_update_units.disconnect(upd)
	
	# not necessary but in case update is not triggered, this is a safeguard
	upd.call()
	
	if attacker.is_dead == defender.is_dead: return null
	return attacker if defender.is_dead else defender

func _prefill_data_siege(attacker: MapParty, defender: MapCity) -> void:
	EventBus.left_units = attacker.parameters.get_unit_data()
	EventBus.right_units = defender.units
	EventBus.left_controller = load(GlobalDefs.get_combat_controller(attacker.faction.controller))
	EventBus.right_controller = load(GlobalDefs.get_combat_controller(defender.city_owner.controller))

func _prefill_data(attacker: MapParty, defender: MapParty) -> void:
	EventBus.left_units = attacker.parameters.get_unit_data()
	EventBus.right_units = defender.parameters.get_unit_data()
	EventBus.left_controller = load(GlobalDefs.get_combat_controller(attacker.faction.controller))
	EventBus.right_controller = load(GlobalDefs.get_combat_controller(defender.faction.controller))

func _load_battle() -> Node:
	EventBus.is_battle_ready = false
	var battle: Control = map.battle_scene.instantiate()
	battle.process_mode = Node.PROCESS_MODE_PAUSABLE
	battle.hide()
	
	# combat starts here because this is when combat scene enters
	# the tree and _ready() is called
	map.add_sibling(battle)
	return battle

func _grant_xp(combat: CombatSystem, left: Array[UnitData], right: Array[UnitData]) -> void:
	combat.grant_xp(left, right)
	_update_units.emit()

signal _update_units

func _switch_to_battle(battle: Control, left: Array[UnitData], right: Array[UnitData]) -> void:
	if not EventBus.is_battle_ready:
		await EventBus.battle_ready
	(battle.find_child("Camera2D", false) as Camera2D).make_current()
	battle.show()
	
	game.ui_layers.switch_to(&"Battle")
	map.process_mode = Node.PROCESS_MODE_DISABLED
	
	var xp_reward_callable := _grant_xp.bind(left, right)
	EventBus.winner_determined.connect(xp_reward_callable)
	await EventBus.battle_ended
	EventBus.winner_determined.disconnect(xp_reward_callable)
	
	game.ui_layers.switch_to(&"Main")
	battle.queue_free()
	map.process_mode = Node.PROCESS_MODE_PAUSABLE
	map.camera.make_current()

func _play_effect(pos: Vector2) -> void:
	var effect := battle_effect.instantiate() as TemporaryEffect
	map.add_child(effect)
	effect.global_position = pos
	await effect.effect_finished

## Moves [Map.active_party] to the specified [param object] and triggers
## interaction [b]if applicable[/b].[br]
## Path which the party is to follow is expected to be highlighted:
## it is retrieved with [method MapVisualizer.get_highlighted_tiles].
func move_active_party_to_object(object: MapInteractableObject) -> void:
	if active_party.is_moving:
		active_party.control.abort_moving()
		return
	var path := visualizer.get_highlighted_tiles()
	if path:
		await active_party.control.walk_along_path(
			path,
			true,
			object
		)
	visualizer.reset_highlights()
	map.clean_hashtable()
	var cost := object.validate_and_interact(active_party)
	if cost > 0: active_party.parameters.subtract_mp(cost)

func move_active_party(coords: Vector2i) -> void:
	if active_party.is_moving:
		active_party.control.abort_moving()
		return
	var path := visualizer.get_highlighted_tiles()
	if not path:
		visualizer.reset_highlights()
		return
	await active_party.control.walk_along_path(path)
	visualizer.reset_highlights()
	
	# moving party creates an empty entry for each tile that party walked over
	map.clean_hashtable()

func abort_active_actions() -> void:
	if active_party and active_party.is_moving:
		await active_party.control.abort_moving()
	visualizer.reset_highlights()

func _check_if_end_in_start(
	starts: Array[Vector2i],
	end: Array[Vector2i],
) -> int:
	var i := 0
	for s in starts:
		if s in end: return i
		i += 1
	return -1

## Finds a path from any tile in [param starts] to any tile in [param ends]
## for the specified [param party]. [br]
## If [param include_start] is [code]false[/code], the starting tile is excluded
## from both passability checks and the resulting path.
## [br][br]
## [b]Note:[/b] Not optimized for large arrays - expects [param starts]
## and [param ends] to contain not more than 10 elements each.
## For larger search spaces may cause performance spikes.
func find_path(
	starts: Array[Vector2i],
	end: Array[Vector2i],
	party: MapParty,
	include_start: bool
) -> Array[Vector2i]:
	if not party: return []
	var path : Array[Vector2i] = []
	var start_index := _check_if_end_in_start(starts, end)
	if start_index >= 0:
		var closest_start := starts[start_index]
		if include_start: path.append(closest_start)
		return path
	
	var _start := Vector2i.ZERO
	var travel_data := TravelData.new(party)
	for start in starts:
		if include_start and \
			not map.path_finder.is_passable(start, travel_data, end):
				continue
		var new_path := map.path_finder.A_star(start, end, travel_data)
		if not path or new_path.size() < path.size():
			path = new_path
			_start = start
	if not path: return []
	if include_start: path.assign([_start] + path)
	return path

func check_object_layer() -> void:
	var min_tile := map.min_tile
	var max_tile := map.max_tile
	for c in map.objects_layer.get_used_cells():
		if c.x < min_tile.x or \
			c.x > max_tile.x:
				push_error("Object layer is bigger than terrain layer!
	object at: " + str(c) + "; map size: " + str(min_tile) + "-" + str(max_tile))

const TILE_DATA = preload("uid://com5psdgcwjm3")

func _create_td_mapping() -> Dictionary[Vector2i, MapFaction]:
	# TODO: make initialization with different players with the same faction
	var mapping: Dictionary[Vector2i, MapFaction] = {}
	for faction in game.get_factions():
		for a_coords in faction.tile_atlas_coords:
			if mapping.has(a_coords):
				print_debug("%s is repeated, it will not be assigned" % str(a_coords))
				mapping[a_coords] = null
			else: mapping[a_coords] = faction
	return mapping

## Initializes an empty [MapTileData] object for every terrain tile.[br]
## This operation is computationally expensive due to the volume of objects created.
## Should be executed behind a loading screen or other masking technique.
func create_tile_data() -> void:
	var data_layer := %TileDataLayer
	var mapping := _create_td_mapping()
	for tile in map.terrain_layer.get_used_cells():
		var data: MapTileData = TILE_DATA.instantiate()
		data.global_position = map.get_global_coords(tile)
		map.tile_data_hashmap[tile] = data
		data_layer.add_child(data)
		data.tile_owner = mapping.get(
			map.terrain_layer.get_cell_atlas_coords(tile)
		)

## Attempts to claim [param tile] for [param faction] with the specified [param power].
## Returns [code]true[/code] if successful, [code]false[/code] otherwise.
func do_tile_claim(tile: MapTileData, faction: MapFaction, power: float = 1.0) -> bool:
	if not tile: return false
	return tile.try_claiming(faction, power)
