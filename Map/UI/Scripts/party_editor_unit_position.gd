class_name PartyEditorUnitPosition
extends TextureRect

@export var party_position: int
@export var reparent_data := false

var unit: PartyEditorUnit
var parent: Node

var parent_owner: MapFaction:
	get:
		var p := parent
		while p:
			if p is MapFaction: return p
			if p is MapInteractableObject: return p.object_owner
			p = p.get_parent()
		return null

const PARTY_EDITOR_UNIT_PREFAB = preload("res://Map/UI/Scenes/party_editor_unit.tscn")

func update_data() -> void:
	if unit: unit.update_data()

## Instantiates and adds a new [PartyEditorUnit] object to this spot.
## Has no effect if [member unit] is already present.
func add_unit(data: UnitData) -> void:
	if not data: return
	if unit: return
	unit = PARTY_EDITOR_UNIT_PREFAB.instantiate()
	unit.unit_data = data
	add_child(unit)
	if unit.is_queued_for_deletion(): unit = null

## Frees [member unit]
func remove_unit() -> void:
	if unit: unit.queue_free()
	unit = null

func move_unit(received_unit: PartyEditorUnit) -> void:
	if not _move_unit_in(received_unit): return
	var other_place := received_unit.get_parent()
	if not _move_unit_out(
		received_unit.unit_data.container,
		received_unit.get_parent().party_position if \
			other_place is PartyEditorUnitPosition else -1
	):
		push_error("Unexpeced failure to move unit")
	
	
	if other_place is PartyEditorUnitPosition:
		other_place.unit = unit
	if unit:
		unit.reparent(other_place, false)
		unit.position = Vector2.ZERO
	unit = received_unit
	received_unit.reparent(self, false)
	received_unit.position = Vector2.ZERO

func _move_unit_out(to: UnitsContainer, pos: int) -> bool:
	if not unit: return true
	if not to: return false
	if unit.unit_data.container == to: return true
	if not to.units_owner.api.ui_filter:
		push_error("Filtered UI input")
		return false
	
	return to.units_owner.api.ui_filter.move_unit(
		unit.unit_data,
		to,
		pos
	)

func _move_unit_in(received_unit: PartyEditorUnit) -> bool:
	if not received_unit: return false
	var received_owner := received_unit.unit_data.unit_owner
	if not received_owner.api.ui_filter:
		push_error("Filtered UI input")
		return false
	var other_place := received_unit.get_parent()
	if other_place == self: return false
	
	return received_owner.api.move_unit(
		received_unit.unit_data,
		parent,
		party_position
	)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is not PartyEditorUnit: return false
	if (data as PartyEditorUnit).unit_data is HeroData:
		return data.unit_data.get_parent() == parent if reparent_data else true
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is PartyEditorUnit:
		move_unit(data)
