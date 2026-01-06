extends ConsumableMapItem

@export var heal := 50

func consume(unit: UnitData) -> void:
	if heal < 0:
		push_error("Negative heal value. Health will be reduced")
	unit.current_hp += heal

func can_be_consumed(unit: UnitData) -> bool:
	if unit.is_dead: return false
	if unit.immunities.has(GlobalDefs.AttackType.Life):
		return false
	return unit.current_hp < unit.max_hp
