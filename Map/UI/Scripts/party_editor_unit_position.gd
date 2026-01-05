class_name PartyEditorUnitPosition
extends TextureRect

@export var party_position: int
@export var reparent_data := false

var unit: PartyEditorUnit
var parent: Node

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
	if not received_unit: return
	var other_place := received_unit.get_parent()
	if other_place == self: return
	if reparent_data:
		if received_unit.unit_data.get_parent() != parent:
			if received_unit.unit_data is HeroData: return
	if other_place is PartyEditorUnitPosition:
		other_place.unit = unit
	if unit:
		if other_place is PartyEditorUnitPosition:
			unit.unit_data.party_position = other_place.party_position
		else: unit.unit_data.party_position = -1
		unit.reparent(other_place, false)
	unit = received_unit
	unit.unit_data.party_position = party_position
	unit.reparent(self, false)
	unit.position = Vector2.ZERO
	if reparent_data:
		unit.unit_data.reparent(parent)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is not PartyEditorUnit: return false
	if (data as PartyEditorUnit).unit_data is HeroData:
		return data.unit_data.get_parent() == parent if reparent_data else true
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is PartyEditorUnit:
		move_unit(data)
