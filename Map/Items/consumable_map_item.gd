@abstract
class_name ConsumableMapItem
extends MapItem

## If negative, item can be used unlimited number of times.
var uses: int = 1

## Performs the consumption effect on the specified [param unit]. [br]
## [b]Note:[/b] Usage tracking is handled by [ConsumableMapItem] wrappers.
@abstract func consume(unit: UnitData) -> void
## Determines if the item can be consumed by the specified [param unit]. [br]
## [b]Note:[/b] Usage tracking is handled by [ConsumableMapItem] wrappers.
@abstract func can_be_consumed(unit: UnitData) -> bool

func can_be_applied_to(where: Variant) -> bool:
	if where is not UnitData: return false
	return can_be_consumed(where) if uses != 0 else false

func apply_to(where: Variant) -> void:
	if where is not UnitData: return
	consume(where)
	if uses < 0: return
	uses -= 1
	if uses <= 0:
		queue_free()
	EventBus.item_used.emit(self)
