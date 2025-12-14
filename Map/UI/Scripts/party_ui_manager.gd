class_name PartyUIManager
extends CanvasLayer

@onready var _0: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition
@onready var _1: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/BacklineContainer/PartyEditorUnitPosition1
@onready var _2: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition2
@onready var _3: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/BacklineContainer/PartyEditorUnitPosition3
@onready var _4: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition4
@onready var _5: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/BacklineContainer/PartyEditorUnitPosition5
@onready var _6: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition6

@onready var places: Array[PartyEditorUnitPosition] = [_0,_1,_2,_3,_4,_5,_6]

@onready var inventory_container: HBoxContainer = %InventoryContainer

@onready var ui_layers: MapUI = $".."
var currently_filled_party: MapParty = null

const ITEM_PREFAB = preload("res://Map/UI/Scenes/party_editor_item.tscn")

func _update_values() -> void:
	# TODO: replace with more optimized version
	# (this one requires freeing and instantiating a lot of objects)
	_fill_party(currently_filled_party)

func _fill_units(party: MapParty) -> void:
	for place in places:
		place.remove_unit()
	for data in party.units:
		if data.party_position < 0: continue
		if data.party_position > places.size(): continue
		places[data.party_position].add_unit(data)

func _fill_items(party: MapParty) -> void:
	for c in inventory_container.get_children():
		c.queue_free()
	for item in party.inventory.items:
		var node: PartyEditorItem = ITEM_PREFAB.instantiate()
		inventory_container.add_child(node)
		node.initialize(item)

func _fill_party(party: MapParty) -> void:
	_fill_units(party)
	_fill_items(party)
	currently_filled_party = party

func _on_visibility_changed() -> void:
	if ui_layers.last_requested_party == currently_filled_party:
		_update_values()
	else:
		_fill_party(ui_layers.last_requested_party)
