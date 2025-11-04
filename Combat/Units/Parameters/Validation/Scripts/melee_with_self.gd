extends BaseValidation

@export var melee_validation: BaseValidation

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if target_spot == attacker.spot: return true
	if not melee_validation:
		push_error("melee_validation is not attached!")
		return false
	return melee_validation.validate_target(attacker, target_spot)
