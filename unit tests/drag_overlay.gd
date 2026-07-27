class_name UnitTests_DragOverlay
extends Control


var this_spot: UnitSpot
const DRAG_UNIT_HINT = preload("uid://dn4avjfud3vkr")

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	this_spot.party.main_system.try_swapping_units(data, this_spot.party_position)
	for s in this_spot.party.unit_spots:
		s.reset_highlight()

func _get_drag_data(at_position: Vector2) -> Variant:
	if not this_spot: return
	if not this_spot.unit: return
	if this_spot.unit.parameters.large_unit: return
	set_drag_preview(DRAG_UNIT_HINT.instantiate())
	for s in this_spot.party.unit_spots:
		s.highlight_externally()
	return this_spot.unit
