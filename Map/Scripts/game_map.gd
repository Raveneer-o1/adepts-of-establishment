class_name GameMap
extends Node

const test_map = preload("res://Map/Scenes/map.tscn")

@onready var ui_layers: MapUI = $UILayers
@onready var turn_manager: MapTurnManager = $TurnManager

var current_map: Map

@onready var factions_in_game: int = $Factions.get_child_count()

@onready var test_faction: MapFaction = $Factions/Faction
@onready var test_faction2: MapFaction = $Factions/Faction2

## Resumes map processing.
func enable_map() -> void:
	current_map.process_mode = Node.PROCESS_MODE_PAUSABLE

## Disables map processing.
func disable_map() -> void:
	current_map.process_mode = Node.PROCESS_MODE_DISABLED

var _temporarily_disabled := false
signal _temp_disabled_ended

## Temporarily disables map processing for an indeterminate duration.
## Returns a signal that emits when map processing is re-enabled. [br][br]
## Reactivation may occur via user action (e.g., pressing ESC). Useful for menus
## where the caller cannot predict when map interaction should resume.
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
	test_faction.api.add_child(c.instantiate())
	test_faction2.api.add_child(c.instantiate())
	current_map.active_faction = test_faction
	(current_map.find_child("MapParty") as MapParty).\
		init_party_parameters(test_faction)
	for i in range(10):
		(current_map.find_child("MapParty%d" % i) as MapParty).\
			init_party_parameters(test_faction2)
	EventBus.map_turn_started.emit(test_faction)
	test_faction.api.turn_started.emit()

func _ready() -> void:
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

func get_faction(index: int) -> MapFaction:
	if index < 0:
		#push_error("Negative faction index")
		return null
	if index >= factions_in_game:
		push_error("Faction index outside bounds")
		return null
	return $Factions.get_child(index)
