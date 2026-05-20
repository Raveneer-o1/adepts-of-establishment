class_name GameMap
extends Node

const test_map = preload("res://Map/Scenes/map.tscn")

@onready var ui_layers: MapUI = $UILayers
@onready var turn_manager: MapTurnManager = $TurnManager
@onready var maps_container: Node = $MapsContainer

var current_map: Map

@export var neutral_faction: MapFaction

# WARNING: this will be replaced with a getter that dynamically finds all factions
@onready var factions_in_game: int = $Factions.get_child_count()

## The faction currently viewing the game screen, controlling information visibility
## and UI action permissions. Determines which faction's perspective is active
## for UI elements, ensuring players access only appropriate data for their view.
var screen_player: MapFaction:
	get: return screen_player
	set(value):
		if value == screen_player: return
		ui_layers.resources_panel.fill_data(value.resource_container)
		screen_player = value
		if awaiting_screen_access.has(value):
			var s := awaiting_screen_access[value]
			awaiting_screen_access.erase(value)
			s.emit()
		_draw_fog_of_war(value)

var awaiting_screen_access: Dictionary[MapFaction, Signal]

func _draw_fog_of_war(faction: MapFaction) -> void:
	for map in get_all_maps():
		for coord in map.tile_data_hashmap:
			if map.tile_data_hashmap[coord].is_under_fog_of_war(faction):
				map.draw_fog_of_war(coord)
			else:
				map.erase_fog_of_war(coord)

func update_visibility(tile: MapTileData) -> void:
	if not tile: return
	if tile.is_under_fog_of_war(screen_player):
		tile.map.draw_fog_of_war(tile.coordinates)
	else:
		tile.map.erase_fog_of_war(tile.coordinates)

## Registers [param faction] for screen access notification.
## Returns [param _signal] unchanged, which will emit (without arguments)
## when the faction becomes the active screen player (see [member screen_player]).
## Useful for UI functions awaiting player context activation. For example:
## [codeblock]
## # ... perform setup
##
## # Wait for player to become active screen controller
## await game.screen_access(faction, _waiting_signal)
##
## # ... execute player-dependent logic
## [/codeblock]
func screen_access(faction: MapFaction, _signal: Signal) -> Signal:
	if faction == screen_player:
		_signal.emit.call_deferred()
		return _signal
	awaiting_screen_access[faction] = _signal
	return _signal

@onready var test_faction: MapFaction = $Factions/Empire
@onready var test_faction2: MapFaction = $Factions/Necropolis
@onready var test_faction_neutral: MapFaction = $Factions/Neutral

## Returns all factions in the game.
func get_factions() -> Array[MapFaction]:
	var res: Array[MapFaction] = []
	res.assign($Factions.get_children())
	return res

## Resumes map processing.
func enable_map() -> void:
	current_map.process_mode = Node.PROCESS_MODE_PAUSABLE

## Disables map processing.
func disable_map() -> void:
	current_map.process_mode = Node.PROCESS_MODE_DISABLED

func get_all_maps() -> Array[Map]:
	var res: Array[Map] = []
	res.assign(maps_container.get_children())
	return res

var _temporarily_disabled := false
signal _temp_disabled_ended

## Temporarily disables map processing for an indeterminate duration.
## Returns a signal that emits when map processing is re-enabled. [br][br]
## Reactivation may occur via user action (e.g., pressing ESC). Useful for menus
## where the caller cannot predict when map interaction should resume.[br][br]
## All connections to the signal are disconnected after the processing.
func temporarily_disable_map() -> Signal:
	disable_map()
	_temporarily_disabled = true
	return _temp_disabled_ended

func load_maps() -> void:
	current_map = test_map.instantiate()
	$MapsContainer.add_child(current_map)

## Updates info on the active party pannel
func update_active_party(party: MapParty) -> void:
	if not party: ui_layers.clear_active_party()
	else: ui_layers.fill_active_party(party)

func _test_init() -> void:
	var c := load(GlobalDefs.get_faction_controller(test_faction.controller))
	var c2 := load(GlobalDefs.get_faction_controller(test_faction2.controller))
	var c3 := load(GlobalDefs.get_faction_controller(test_faction_neutral.controller))
	test_faction.api.add_child(c.instantiate())
	test_faction2.api.add_child(c2.instantiate())
	test_faction_neutral.api.add_child(c3.instantiate())
	current_map.active_faction = test_faction
	EventBus.map_turn_started.emit(test_faction)
	test_faction.api.turn_started.emit()

func _ready() -> void:
	assert(neutral_faction)
	load_maps()
	ui_layers.clear_active_party()
	_test_init()

func _end_temporary_disable() -> void:
	enable_map()
	_temporarily_disabled = false
	_temp_disabled_ended.emit()
	for d: Dictionary in _temp_disabled_ended.get_connections():
		_temp_disabled_ended.disconnect(d.callable)

func _on_h_box_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: _end_temporary_disable()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed(): return
	if _temporarily_disabled:
		get_viewport().set_input_as_handled()
		if (event as InputEventKey).keycode == Key.KEY_ESCAPE:
			_end_temporary_disable()

## Returns the faction with the specified [param index] or [code]null[/code].
func get_faction(index: int) -> MapFaction:
	if index < 0:
		#push_error("Negative faction index")
		return null
	if index >= factions_in_game:
		push_error("Faction index outside bounds")
		return null
	return $Factions.get_child(index)

## Instantiates and initializes a new [UnitData] object with the specified name
## and adds it as a child to the provided [param container]
## Units are identified by name only - ensure [param unit_name] matches database exactly.
## If the database marks the unit as a hero (non-empty [code]hero_abilities[/code]
## entry), returns a [HeroData] instance.[br][br]
## If instantiation failed, returns [code]null[/code].
func spawn_new_unit(
	unit_name: StringName,
	container: UnitsContainer,
	personal_name: String = ""
) -> UnitData:
	if not unit_name: return null
	if not container: return null
	var data := UnitData.get_new(unit_name, personal_name)
	if not data: return null
	container.add_child(data)
	return data

const MAP_PARTY = preload("uid://2kk6w327nvk")

## Spawns a new [MapParty] at [param coords] on the specified [param _map].
## If there is a [MapCity] object on the provided tile, newly generated party
## will try to enter that city.
## This bypasses is_enemy() calls, so the party can potentially end up inside 
## the city of an enemy.
func spawn_new_party(
	coords: Vector2i,
	owner_faction: MapFaction,
	_map: Map = current_map,
) -> MapParty:
	var obj: MapParty = MAP_PARTY.instantiate()
	obj.global_position = _map.get_global_coords(coords)
	obj.object_owner = owner_faction
	_map.find_child("Parties", false).add_child(obj)
	for o: MapInteractableObject in _map.tile_to_object.get(coords, []):
		if o is MapCity:
			await obj.enter_city(o)
			break
	return obj
