extends BaseValidation

func _validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null or \
			target_spot == null or \
			target_spot.unit == null or\
			target_spot.unit.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target_spot.unit):
		return false
	return true
