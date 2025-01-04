class_name UnitAttack

var unit: Unit
var damage_multiplier := 1.0
var damage_override := -1
#var target_validation_override: bool = false
var target_validation : Callable
var type: EventBus.AttackType
var accuracy: float
var targets_needed: int
var initiative: int

func  _init(_unit: Unit, dmg_mult: float, dmg_ov: bool,
		valid: Callable, ty: EventBus.AttackType, acc: float,
		targets: int, _initiative: int) -> void:
	unit = _unit
	damage_multiplier = dmg_mult
	damage_override = dmg_ov
	#target_validation_override = valid_ov
	target_validation = valid
	type = ty
	accuracy = acc
	targets_needed = targets
	initiative = _initiative
