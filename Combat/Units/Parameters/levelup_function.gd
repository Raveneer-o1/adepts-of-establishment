@abstract
class_name LevelupFunction
extends Resource

## Performs custom level-up logic for the unit.
## This function is responsible for incrementing [member UnitData.level] -
## this is not managed automatically.[br][br]
## Typically includes a [constant LevelupFunction.MAX_LEVEL] check to align with
## design philosophy (limiting single-unit power to encourage army diversification).
## However, this convention is not enforced - units may implement custom progression
## rules.
@abstract func custom_levelup(unit: UnitData) -> void

const MAX_LEVEL = 10

const _HP_INCREASE_FACTOR = 1.1
const _DMG_INCREASE_FACTOR = 1.1

static func _levelup(unit: UnitData) -> void:
	@warning_ignore("narrowing_conversion")
	unit.max_hp *= _HP_INCREASE_FACTOR
	@warning_ignore("narrowing_conversion")
	unit.base_damage *= _DMG_INCREASE_FACTOR

## Levels up the unit using class-based progression (see [member Unit.unit_class]).
## Units at [constant MAX_LEVEL] receive only secondary benefits (e.g., full healing).
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
			_:  # UnitClass.Undefined processed here
				_levelup(unit)
	
	unit.current_hp = unit.max_hp
