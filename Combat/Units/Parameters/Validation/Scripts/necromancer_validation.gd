extends BaseValidation

func _validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null or target_spot == null:
		return false
	
	# if units are in the same party, we don't attack unless it's possible to resurrect
	if attacker.party == target_spot.party:
		if target_spot.unit != null:
			return false
		if target_spot.corpse_container.get_child_count() == 0:
			return false
	
	return true
