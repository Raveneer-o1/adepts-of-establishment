class_name GameMap
extends Node

const test_map = preload("res://Map/Scenes/map.tscn")

@onready var _active_party_container: VBoxContainer = %ActivePartyContainer
@onready var _party_name_label: Label = %ActivePartyContainer/PartyNameLabel
@onready var _movement_points: ProgressBar = %ActivePartyContainer/MovementPoints
@onready var _movement_points_label: Label = %ActivePartyContainer/MovementPoints/Label
@onready var _party_portrait_texture_rect: TextureRect = \
	%ActivePartyContainer/PortraitContainer/PanelContainer/PortraitTextureRect

@onready var ui_layers: MapUI = $UILayers
@onready var turn_manager: MapTurnManager = $TurnManager

var current_map: Map

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

func _clear_active_party() -> void:
	_movement_points.value = 0.0
	_movement_points_label.text = ""
	_party_name_label.text = ""
	
	# TODO: dynamically place textures
	_party_portrait_texture_rect.hide()

func _fill_active_party(party: MapParty) -> void:
	var mp := party.parameters.movement_points
	var max_mp := party.parameters.max_movement_points
	_movement_points.value = mp
	_movement_points.max_value = max_mp
	_movement_points_label.text = "%d/%d" % [mp, max_mp]
	_party_name_label.text = party.party_name
	
	if _party_portrait_texture_rect.texture != party.loaded_portrait:
		_party_portrait_texture_rect.texture = party.loaded_portrait
	_party_portrait_texture_rect.show()
	
	ui_layers.fill_active_party(party)

## Updates info on the active party pannel
func update_active_party(party: MapParty) -> void:
	if not party: _clear_active_party()
	else: _fill_active_party(party)

func _test_init() -> void:
	var c := load(GlobalDefs.get_faction_controller(test_faction.controller))
	test_faction.api.add_child(c.instantiate())
	test_faction2.api.add_child(c.instantiate())
	current_map.active_faction = test_faction
	(current_map.find_child("MapParty") as MapParty).faction = test_faction
	(current_map.find_child("MapParty2") as MapParty).faction = test_faction2
	(current_map.find_child("MapParty3") as MapParty).faction = test_faction
	EventBus.map_turn_started.emit(test_faction)
	test_faction.api.turn_started.emit()

func _ready() -> void:
	load_maps()
	_clear_active_party()
	
	_test_init()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed(): return
	if _temporarily_disabled:
		get_viewport().set_input_as_handled()
		if (event as InputEventKey).keycode == Key.KEY_ESCAPE:
			enable_map()
			_temp_disabled_ended.emit()
			for d: Dictionary in _temp_disabled_ended.get_connections():
				_temp_disabled_ended.disconnect(d.callable)
