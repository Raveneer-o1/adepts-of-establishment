extends BasePolicy

func apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots.is_empty():
		return
	if index < 0 or index >= attack.target_spots.size():
		return
	
	var spot := attack.target_spots[index]
	if spot == null:
		return
	
	var attacker := attack.attacker
	
	if spot.party == attack.attacker.party:
		if attacker.parameters.other_effects.is_empty():
			print_debug("No Elemental prefab found!")
			return
		spot.add_unit(attacker.parameters.other_effects[0])
		return
	
	if spot.unit == null:
		return
	
	spot.unit.resolve_attack(attack, index, finalize)
