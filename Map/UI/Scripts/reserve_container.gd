class_name ReserveContainer
extends ScrollContainer

const PARTY_EDITOR_UNIT_PREFAB = preload("res://Map/UI/Scenes/party_editor_unit.tscn")
var parent: Node

var parent_owner: MapFaction:
	get:
		var p := parent
		while p:
			if p is MapFaction: return p
			if p is MapInteractableObject: return p.object_owner
			p = p.get_parent()
		return null


func add_unit(data: UnitData) -> void:
	if not data: return
	var unit := PARTY_EDITOR_UNIT_PREFAB.instantiate()
	unit.unit_data = data
	$VBoxContainer.add_child(unit)

# HACK: This function checks for valid movements but does not go through API
func move_unit(received_unit: PartyEditorUnit) -> void:
	var received_owner := received_unit.unit_data.unit_owner
	if received_owner != parent_owner:
		push_error("Trying to move unit to different owner")
		return
	if not received_owner.api.ui_filter:
		push_error("Filtered UI input")
		return
	if parent and received_unit.unit_data is HeroData and \
			received_unit.unit_data.get_parent() != parent: return
	var other_place := received_unit.get_parent()
	if other_place == self: return
	if other_place is PartyEditorUnitPosition:
		other_place.unit = null
	#elif other_place is ReserveContainer:
	received_unit.unit_data.party_position = -1
	received_unit.reparent($VBoxContainer, false)
	if parent and received_unit.unit_data.get_parent() != parent:
		received_unit.unit_data.move_unit(parent)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is not PartyEditorUnit: return false
	if (data as PartyEditorUnit).unit_data is HeroData:
		return data.unit_data.get_parent() == parent if parent else true
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is PartyEditorUnit:
		move_unit(data)

func get_units() -> Array[PartyEditorUnit]:
	var res: Array[PartyEditorUnit] = []
	res.assign($VBoxContainer.get_children())
	return res
