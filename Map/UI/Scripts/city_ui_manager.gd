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
	#if currently_filled_city == city: update_city()
	
	garrison_reserve_container.parent = city.units_container
	party_reserve_container.parent = city.party_inside.units_container \
		if city.party_inside else null
	for place in places:
		place.remove_unit()
		place.parent = city.units_container
	for place in party_places:
		place.remove_unit()
		place.parent = city.party_inside.units_container \
			if city.party_inside else null
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
	# WARNING: very inefficient, might need a redesign after profiling
	fill_city_data.call_deferred(currently_filled_city)

func _request_party_hiring() -> void:
	if not currently_filled_city.object_owner: return
	var ui_filter := currently_filled_city.object_owner.api.ui_filter
	if not ui_filter: return
	
	var heroes_list := ui_filter.this_api.get_heroes_list()
	if not EventBus.party_hired.is_connected(update_city):
		EventBus.party_hired.connect(update_city)
	ui_layers.open_hero_hire_popup(currently_filled_city, heroes_list)

func _on_hire_button_pressed() -> void:
	if not currently_filled_city.object_owner: return
	if not currently_filled_city.object_owner.api.ui_filter: return
	if not EventBus.unit_hired.is_connected(update_city):
		EventBus.unit_hired.connect(update_city)
	ui_layers.open_hire_popup(
		currently_filled_city.units_container,
		currently_filled_city.get_available_units()
	)

func _on_hire_party_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if currently_filled_city and not currently_filled_city.party_inside:
			_request_party_hiring()
