extends BaseValidation

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null or \
			target_spot == null:
		return false
	
	if target_spot.party == attacker.party:
		if target_spot.unit: return false
		return true
	
	if target_spot.unit: return true
	return false
