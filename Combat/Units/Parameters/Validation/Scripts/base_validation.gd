extends Resource
class_name BaseValidation

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	return validate_position_pair(attacker.spot, target_spot)

func validate_position_pair(attacker: UnitSpot, target: UnitSpot) -> bool:
	return true
