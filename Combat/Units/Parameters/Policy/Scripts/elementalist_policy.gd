extends BasePolicy

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs: Array[UnitSpotReference] = []
	for t: UnitSpotReference in attack.target_references:
		if not t: continue
		if not t.spot: continue
		if t.spot.party == attack.attacker.party:
			if attack.attacker.parameters.other_effects.is_empty():
				push_error("No Elemental prefab found!")
				return
			# no need to raise an error because policy
			# is supposed to work with what it has
			if t.spot.unit: return
			var u := t.spot.add_unit(attack.attacker.parameters.other_effects[0], null)
			if u: u.summoned_unit = true
			continue
		new_refs.append(t)
	attack.target_references = new_refs
	attack.standard_resolution(finalize)
