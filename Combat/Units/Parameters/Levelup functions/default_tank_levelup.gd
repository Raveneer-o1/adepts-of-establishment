class_name __DefaultTank__

const HP_INCREASE_FACTOR = 1.1
const DMG_INCREASE_FACTOR = 1.05
const ARMOR_INCREASE_FACTOR = 1.15

static func levelup(unit: UnitData) -> void:
	@warning_ignore("narrowing_conversion")
	unit.max_hp *= HP_INCREASE_FACTOR
	@warning_ignore("narrowing_conversion")
	unit.base_damage *= DMG_INCREASE_FACTOR
	@warning_ignore("narrowing_conversion")
	unit.armor *= ARMOR_INCREASE_FACTOR
