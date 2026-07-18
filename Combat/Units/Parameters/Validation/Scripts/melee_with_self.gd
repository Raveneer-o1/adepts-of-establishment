extends BaseValidation

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	return target_spot == attacker.spot
	#if not melee_validation:
		#push_error("melee_validation is not attached!")
		#return false
	#return melee_validation.validate_target(attacker, target_spot)
