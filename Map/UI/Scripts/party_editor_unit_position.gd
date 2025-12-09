class_name PartyEditorUnitPosition
extends TextureRect

@export var party_position: int

var unit: PartyEditorUnit

const PARTY_EDITOR_UNIT_PREFAB = preload("res://Map/UI/Scenes/party_editor_unit.tscn")

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

func _move_unit(received_unit: PartyEditorUnit) -> void:
	var other_place: PartyEditorUnitPosition = received_unit.get_parent()
	if other_place == self: return
	other_place.unit = unit
	if unit:
		unit.unit_data.party_position = other_place.party_position
		unit.reparent(other_place, false)
	unit = received_unit
	unit.unit_data.party_position = party_position
	unit.reparent(self, false)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is PartyEditorUnit

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is PartyEditorUnit:
		_move_unit(data)
