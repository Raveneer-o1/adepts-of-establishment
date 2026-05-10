extends BaseValidation

# FIXME: check for occupied spot

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null or \
			target_spot == null:
		return false
	
	return true
