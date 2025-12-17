class_name CityUIManager
extends Node

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

@onready var places: Array[PartyEditorUnitPosition] = [g_0, g_1, g_2, g_3, g_4, g_5, g_6]
@onready var party_places: Array[PartyEditorUnitPosition] = [_0, _1, _2, _3, _4, _5, _6]

var currently_filled_city: MapCity = null

func fill_city_data(city: MapCity) -> void:
	for place in places:
		if place.unit: place.unit.free()
		place.parent = city
	for place in party_places:
		if place.unit: place.unit.free()
		place.parent = city.party_inside
	%PartyUnitsContainer.visible = true if city.party_inside else false
	for data in city.units:
		if data.party_position < 0: continue
		if data.party_position > places.size(): continue
		places[data.party_position].add_unit(data)
	if city.party_inside:
		for data in city.party_inside.units:
			if data.party_position < 0: continue
			if data.party_position > party_places.size(): continue
			party_places[data.party_position].add_unit(data)
	
	currently_filled_city = city
