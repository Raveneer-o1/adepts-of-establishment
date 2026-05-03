extends ConsumableMapItem

@export var heal := 50

func get_description() -> String:
	if heal > 0:
		return "This potion restores %d health" % heal
	return description

func consume(unit: UnitData) -> void:
	if heal < 0:
		push_error("Negative heal value. Health will be reduced")
	unit.current_hp = clampi(unit.current_hp + heal, 0, unit.max_hp)

func can_be_consumed(unit: UnitData) -> bool:
	if unit.is_dead: return false
	if unit.immunities.has(GlobalDefs.AttackType.Life):
		return false
	return unit.current_hp < unit.max_hp
