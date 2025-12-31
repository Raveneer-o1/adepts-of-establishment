@abstract
class_name LevelupFunction
extends Resource

@abstract func custom_levelup(unit: UnitData) -> void

const HP_INCREASE_FACTOR = 0.1
const MAX_HP_INCREASE_FACTOR = 10.0
const MAX_HP_INCREASE_FIRST_LEVEL = 20.0
const DMG_INCREASE_FACTOR = 0.1
const MAX_DMG_INCREASE_FACTOR = 5.0
const MAX_DMG_INCREASE_FIRST_LEVEL = 10.0

const ARMOR_INCREASE_FACTOR = 0.2
const MAX_ARMOR_INCREASE_FACTOR = 0.5
const MAX_ARMOR_INCREASE_FIRST_LEVEL = 1.0

static func default_levelup(unit: UnitData) -> void:
	unit.level += 1
	var hp_increase := clampf(
		unit.max_hp * HP_INCREASE_FACTOR,
		0.0,
		MAX_HP_INCREASE_FIRST_LEVEL + (unit.level - 1) * MAX_HP_INCREASE_FACTOR
	)
	unit.max_hp += int(hp_increase)
	var dmg_increase := clampf(
		unit.base_damage * DMG_INCREASE_FACTOR,
		0.0,
		MAX_DMG_INCREASE_FIRST_LEVEL + (unit.level - 1) * MAX_DMG_INCREASE_FACTOR
	)
	unit.base_damage += int(dmg_increase)
	match unit.unit_type:
		GlobalDefs.UnitType.Melee:
			var armor_increase := clampf(
				unit.armor * ARMOR_INCREASE_FACTOR,
				0.0,
				MAX_ARMOR_INCREASE_FIRST_LEVEL + (unit.level - 1) * MAX_ARMOR_INCREASE_FACTOR
			)
			unit.armor += int(armor_increase)
	unit.current_hp = unit.max_hp
