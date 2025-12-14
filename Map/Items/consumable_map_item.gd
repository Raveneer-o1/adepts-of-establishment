@abstract
class_name ConsumableMapItem
extends MapItem

@abstract func consume(unit: UnitData) -> void
@abstract func can_be_consumed(unit: UnitData) -> bool

func can_be_applied_to(where: Variant) -> bool:
	return where is UnitData

func apply_to(where: Variant) -> void:
	if where is not UnitData: return
