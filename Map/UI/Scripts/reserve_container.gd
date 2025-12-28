class_name ReserveContainer
extends ScrollContainer

const PARTY_EDITOR_UNIT_PREFAB = preload("res://Map/UI/Scenes/party_editor_unit.tscn")
var parent: Node


## Instantiates and adds a new [PartyEditorUnit] object to this spot.
## Has no effect if [member unit] is already present.
func add_unit(data: UnitData) -> void:
	if not data: return
	var unit := PARTY_EDITOR_UNIT_PREFAB.instantiate()
	unit.unit_data = data
	$VBoxContainer.add_child(unit)

func move_unit(received_unit: PartyEditorUnit) -> void:
	var other_place := received_unit.get_parent()
	if other_place == self: return
	if other_place is PartyEditorUnitPosition:
		other_place.unit = null
	#elif other_place is ReserveContainer:
	received_unit.unit_data.party_position = -1
	received_unit.reparent($VBoxContainer, false)
	if parent and received_unit.unit_data.get_parent() != parent:
		received_unit.unit_data.reparent(parent)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is PartyEditorUnit

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is PartyEditorUnit:
		move_unit(data)

func get_units() -> Array[PartyEditorUnit]:
	var res: Array[PartyEditorUnit] = []
	res.assign($VBoxContainer.get_children())
	return res
