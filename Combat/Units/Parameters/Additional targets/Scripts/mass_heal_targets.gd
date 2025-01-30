extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	var result : Array[UnitSpot] = []
	for u in attacker.party.units:
		if u == null or u.parameters.dead:
			continue
		if chosen_targets.has(u.spot):
			continue
		
		result.append(u.spot)
	return result
