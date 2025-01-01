class_name UnitAttack

var damage_multiplier := 1.0
var damage_override := -1
var target_validation_override: bool = false
var target_validation : Callable
var type: EventBus.AttackType
var accuracy: float

func  _init(dmg_mult: float, dmg_ov: bool, valid_ov: bool, valid: Callable, ty: EventBus.AttackType, acc: float) -> void:
	damage_multiplier = dmg_mult
	damage_override = dmg_ov
	target_validation_override = valid_ov
	target_validation = valid
	type = ty
	accuracy = acc
