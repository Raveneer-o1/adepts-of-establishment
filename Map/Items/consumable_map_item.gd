@abstract
class_name ConsumableMapItem
extends MapItem

var uses: int = 1

@abstract func consume(unit: UnitData) -> void
@abstract func can_be_consumed(unit: UnitData) -> bool

func can_be_applied_to(where: Variant) -> bool:
	if where is not UnitData: return false
	return can_be_consumed(where)

func apply_to(where: Variant) -> void:
	if where is not UnitData: return
	consume(where)
	if uses < 0: return
	uses -= 1
	if uses <= 0:
		queue_free()
	EventBus.item_used.emit(self)
