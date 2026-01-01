class_name __DefaultRogue__

const HP_INCREASE_FACTOR = 1.05
const DMG_INCREASE_FACTOR = 1.1
const EVASION_INCREASE_FACTOR = 1.125

static func levelup(unit: UnitData) -> void:
	@warning_ignore("narrowing_conversion")
	unit.max_hp *= HP_INCREASE_FACTOR
	@warning_ignore("narrowing_conversion")
	unit.base_damage *= DMG_INCREASE_FACTOR
	unit.evasion *= EVASION_INCREASE_FACTOR
