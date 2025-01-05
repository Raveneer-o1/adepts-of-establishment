class_name UnitAttack

var unit: Unit
var damage_multiplier := 1.0
var damage_override := -1
var target_validation : Callable
var type: EventBus.AttackType
var accuracy: float
var targets_needed: int
var initiative: int

## function with a signature (attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit]
## sets list of auto-determined targets
## Note: if combined with damage_policy, pay attention to the order of added units
var find_additional_targets: Callable

## function with a signature (attack: Attack, index: int) -> void
## overrides resolve_attack and applies to all targets using their indexes
var damage_policy: Callable

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
