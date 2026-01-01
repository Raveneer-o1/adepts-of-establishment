@abstract
class_name LevelupFunction
extends Resource

@abstract func custom_levelup(unit: UnitData) -> void

const MAX_LEVEL = 10

const _HP_INCREASE_FACTOR = 1.1
const _DMG_INCREASE_FACTOR = 1.1

static func _levelup(unit: UnitData) -> void:
	@warning_ignore("narrowing_conversion")
	unit.max_hp *= _HP_INCREASE_FACTOR
	@warning_ignore("narrowing_conversion")
	unit.base_damage *= _DMG_INCREASE_FACTOR

static func default_levelup(unit: UnitData) -> void:
	if unit.level < MAX_LEVEL:
		unit.level += 1
		
		match unit.unit_class:
			UnitData.UnitClass.Warrior:
				__DefaultWarrior__.levelup(unit)
			UnitData.UnitClass.Tank:
				__DefaultTank__.levelup(unit)
			UnitData.UnitClass.Rogue:
				__DefaultRogue__.levelup(unit)
			UnitData.UnitClass.Archer:
				__DefaultArcher__.levelup(unit)
			UnitData.UnitClass.Mage:
				__DefaultMage__.levelup(unit)
			_:  # UnitClass.Undefined will be here
				_levelup(unit)
	
	unit.current_hp = unit.max_hp
