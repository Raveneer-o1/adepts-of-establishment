class_name CityUIManager
extends CanvasLayer

@onready var ui_layers: MapUI = $".."

@onready var _0: PartyEditorUnitPosition = \
	%PartyUnitsContainer/FrontlineContainer/PartyEditorUnitPosition
@onready var _1: PartyEditorUnitPosition = \
	%PartyUnitsContainer/BacklineContainer/PartyEditorUnitPosition1
@onready var _2: PartyEditorUnitPosition = \
	%PartyUnitsContainer/FrontlineContainer/PartyEditorUnitPosition2
@onready var _3: PartyEditorUnitPosition = \
	%PartyUnitsContainer/BacklineContainer/PartyEditorUnitPosition3
@onready var _4: PartyEditorUnitPosition = \
	%PartyUnitsContainer/FrontlineContainer/PartyEditorUnitPosition4
@onready var _5: PartyEditorUnitPosition = \
	%PartyUnitsContainer/BacklineContainer/PartyEditorUnitPosition5
@onready var _6: PartyEditorUnitPosition = \
	%PartyUnitsContainer/FrontlineContainer/PartyEditorUnitPosition6

@onready var g_0: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/FrontlineContainer/PartyEditorUnitPosition
@onready var g_1: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/BacklineContainer/PartyEditorUnitPosition1
@onready var g_2: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/FrontlineContainer/PartyEditorUnitPosition2
@onready var g_3: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/BacklineContainer/PartyEditorUnitPosition3
@onready var g_4: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/FrontlineContainer/PartyEditorUnitPosition4
@onready var g_5: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/BacklineContainer/PartyEditorUnitPosition5
@onready var g_6: PartyEditorUnitPosition = \
	%GarrisonUnitsContainer/FrontlineContainer/PartyEditorUnitPosition6

@onready var garrison_reserve_container: ReserveContainer = \
	$PanelContainer/MarginContainer/HBoxContainer/GarrisonReserveContainer
@onready var party_reserve_container: ReserveContainer = \
	$PanelContainer/MarginContainer/HBoxContainer/PartyReserveContainer

@onready var places: Array[PartyEditorUnitPosition] = [g_0, g_1, g_2, g_3, g_4, g_5, g_6]
@onready var party_places: Array[PartyEditorUnitPosition] = [_0, _1, _2, _3, _4, _5, _6]

var currently_filled_city: MapCity = null

func fill_city_data(city: MapCity) -> void:
	# HACK: add a safeguard similar to this to every UI function
	# There's no other checks for invalid access throughout the whole process
	# of UI interactions, so we need to be very sure that players can never open
	# windows they're not supposed to
	if not ui_layers.game_map.screen_player or \
		ui_layers.game_map.screen_player != city.object_owner: return
	# TODO: route the entire UI process throgh FactionAPI class,
	# so all the functions go nowhere unless the controller permits it
	
	# HACK: implement update_city() properly
	#if currently_filled_city == city: update_city()
	
	garrison_reserve_container.parent = city
	party_reserve_container.parent = city.party_inside
	for place in places:
		place.remove_unit()
		place.parent = city
	for place in party_places:
		place.remove_unit()
		place.parent = city.party_inside
	for unit in garrison_reserve_container.get_units():
		unit.queue_free()
	for unit in party_reserve_container.get_units():
		unit.queue_free()
	
	%PartyUnitsContainer.visible = true if city.party_inside else false
	
	for data in city.units:
		if data.party_position < 0:
			garrison_reserve_container.add_unit(data)
			continue
		if data.party_position > places.size(): continue
		places[data.party_position].add_unit(data)
	if city.party_inside:
		for data in city.party_inside.parameters.get_unit_data():
			if data.party_position < 0:
				party_reserve_container.add_unit(data)
				continue
			if data.party_position > party_places.size(): continue
			party_places[data.party_position].add_unit(data)
	
	currently_filled_city = city

func update_city(...args: Array) -> void:
	# WARNING: very inefficient, needs redesign
	fill_city_data.call_deferred(currently_filled_city)

func _request_party_hiring() -> void:
	if not currently_filled_city.object_owner: return
	currently_filled_city.object_owner.api.hire_party(
		currently_filled_city.tile_position,
		currently_filled_city.map
	)
	update_city()

func _on_hire_button_pressed() -> void:
	$"..".open_hire_popup(
		currently_filled_city,
		update_city,
		currently_filled_city.get_avaliable_units()
	)

func _on_hire_party_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if currently_filled_city and not currently_filled_city.party_inside:
			_request_party_hiring()
