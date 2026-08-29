extends BaseValidation

@export var only_small_units := false

func validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if not target_spot.unit: return false
	if not only_small_units: return true
	return not target_spot.unit.parameters.large_unit
