extends BaseValidation

func _validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null or \
			target_spot == null:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.unit_spots.has(target_spot):
		return false
	
	return true
