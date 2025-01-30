extends BaseValidation


func _validate_target(attacker: Unit, target_spot: UnitSpot) -> bool:
	if target_spot.party != attacker.party:
		return false
	
	if target_spot.unit != null:
		return false
	
	if target_spot.corpse_container.get_children().is_empty():
		return false
	
	return true
