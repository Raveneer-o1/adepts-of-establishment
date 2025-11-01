extends BasePolicy

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs: Array[UnitSpotReference] = []
	for t: UnitSpotReference in attack.target_references:
		if not t.spot: continue
		# no need to check for vacancy because any policy should work with what it has
		# also, UnitSpot.add_unit() checks for invalid attempts
		if t.spot.party == attack.attacker.party:
			if attack.attacker.parameters.other_effects.is_empty():
				print_debug("No Elemental prefab found!")
				return
			t.spot.add_unit(attack.attacker.parameters.other_effects[0])
			continue
		new_refs.append(t)
	attack.target_references = new_refs
	attack.standard_resolution(finalize)
