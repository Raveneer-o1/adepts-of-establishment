extends BasePolicy

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs: Array[UnitSpotReference] = []
	for target in attack.target_references:
		if not target.spot: continue
		if target.spot.party == attack.attacker.party:
			if attack.attacker.system.try_swapping_units(
				attack.attacker, 
				target.spot.party_position
			): break
			else: continue
		if target.spot.unit: new_refs.append(target)
	
	if new_refs:
		attack.target_references = new_refs
		attack.standard_resolution()
