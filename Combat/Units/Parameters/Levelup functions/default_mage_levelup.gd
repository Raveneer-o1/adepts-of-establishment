class_name __DefaultMage__

const DMG_INCREASE_FACTOR = 1.2

static func levelup(unit: UnitData) -> void:
	@warning_ignore("narrowing_conversion")
	unit.base_damage *= DMG_INCREASE_FACTOR
