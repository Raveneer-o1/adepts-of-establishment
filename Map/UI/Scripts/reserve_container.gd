class_name ReserveContainer
extends ScrollContainer

## Party position of a unit assigned to this container.
const PARTY_POSITION = -1
const PARTY_EDITOR_UNIT_PREFAB = preload("res://Map/UI/Scenes/party_editor_unit.tscn")
## If specified, the container will reparent an assigned unit to this node.
## Typically set to the [UnitsContainer] object that holds the unit as a child.
var parent: Node

## Instantiates and adds a new [PartyEditorUnit] object to this container.
func add_unit(data: UnitData) -> void:
	if not data: return
	var unit := PARTY_EDITOR_UNIT_PREFAB.instantiate()
	unit.unit_data = data
	$VBoxContainer.add_child(unit)

## Moves the provided [param received_unit] to this reserve container.
## If [member parent] is specified, the unit will be reparented to that node.
func move_unit(received_unit: PartyEditorUnit) -> void:
	if not received_unit: return
	var received_owner := received_unit.unit_data.unit_owner
	if not received_owner.api.ui_filter:
		push_error("Filtered UI input")
		return
	
	if not received_owner.api.move_unit(
		received_unit.unit_data,
		parent,
		PARTY_POSITION
	):
		return
	
	var other_place := received_unit.get_parent()
	if other_place == self: return
	if other_place is PartyEditorUnitPosition:
		other_place.unit = null
	#elif other_place is ReserveContainer:
	#received_unit.unit_data.party_position = -1
	received_unit.reparent($VBoxContainer, false)
	received_unit.position = Vector2.ZERO

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
