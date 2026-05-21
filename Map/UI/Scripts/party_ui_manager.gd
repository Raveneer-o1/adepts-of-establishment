class_name PartyUIManager
extends CanvasLayer

@onready var _0: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition
@onready var _1: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/BacklineContainer/PartyEditorUnitPosition1
@onready var _2: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition2
@onready var _3: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/BacklineContainer/PartyEditorUnitPosition3
@onready var _4: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition4
@onready var _5: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/BacklineContainer/PartyEditorUnitPosition5
@onready var _6: PartyEditorUnitPosition = $HBoxContainer/PanelContainer/HBoxContainer/UnitsContainer/FrontlineContainer/PartyEditorUnitPosition6
@onready var reserve_container: ReserveContainer = %UI_Party_ReserveContainer

@onready var places: Array[PartyEditorUnitPosition] = [_0,_1,_2,_3,_4,_5,_6]

@onready var inventory_container: HBoxContainer = %InventoryContainer
@onready var equipment_v_box_container: EquipmentVBoxContainer = %EquipmentVBoxContainer

@onready var ui_layers: MapUI = $".."
var currently_filled_party: MapParty = null

const ITEM_PREFAB = preload("res://Map/UI/Scenes/party_editor_item.tscn")


func _create_mapping() -> Dictionary[PartyEditorUnitPosition, UnitData]:
	var res: Dictionary[PartyEditorUnitPosition, UnitData] = {}
	var size := places.size()
	for data in currently_filled_party.units:
		if data.party_position < 0: continue
		if data.party_position >= size: continue
		var pos := places[data.party_position]
		if res.has(pos):
			# Detected duplicate position assignment -
			# revert to complete object cleanup and reinstantiation
			push_error("Double assignment to position detected!")
			return {}
		res[pos] = data
	
	return res

func _is_place_ok(place: PartyEditorUnitPosition) -> bool:
	if not place.unit: return true
	place.update_data()
	return true

func _find_position(data: UnitData) -> PartyEditorUnitPosition:
	for place in places:
		if not place.unit: continue
		if place.unit.unit_data == data: return place
	return null

func _update_values() -> void:
	if not currently_filled_party: return
	# TODO: the equipped items section should be checked here
	var mapping := _create_mapping()
	if mapping.is_empty():
		_fill_party(currently_filled_party)
		return
	
	var vacant_spots: Array[PartyEditorUnitPosition] = []
	for place in places:
		place.update_data()
		if place not in mapping:
			if place.unit: vacant_spots.append(place)
			continue
		if not place.unit or place.unit.unit_data != mapping[place]:
			var pos := _find_position(mapping[place])
			if not pos:
				place.remove_unit()
				place.add_unit(mapping[place])
			else:
				place.move_unit(pos.unit)
			continue

func _remove_data() -> void:
	for place in places:
		place.remove_unit()
	for c in inventory_container.get_children():
		c.queue_free()
	for c in equipment_v_box_container.get_children():
		c.queue_free()

func _fill_units(party: MapParty) -> void:
	for data in party.units:
		if data.party_position < 0 or \
			data.party_position >= places.size():
				reserve_container.add_unit(data)
		else: places[data.party_position].add_unit(data)

func _fill_items(party: MapParty) -> void:
	for item in party.inventory.items:
		var node: PartyEditorItem = ITEM_PREFAB.instantiate()
		@warning_ignore("incompatible_ternary")
		var container: Node = equipment_v_box_container if \
			item is EquippableMapItem and item.is_equipped() \
			else inventory_container
		container.add_child(node)
		node.initialize(item)

func _fill_party(party: MapParty) -> void:
	_remove_data()
	_fill_units(party)
	_fill_items(party)
	currently_filled_party = party

func _on_visibility_changed() -> void:
	if not visible: return
	if ui_layers.last_requested_party == currently_filled_party:
		_update_values()
	else:
		_fill_party(ui_layers.last_requested_party)
