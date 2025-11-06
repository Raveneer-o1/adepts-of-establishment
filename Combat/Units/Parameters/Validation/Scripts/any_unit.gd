extends BaseValidation

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	return target_spot.unit != null
