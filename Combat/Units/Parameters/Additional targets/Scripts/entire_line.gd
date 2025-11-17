extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	var result: Array[UnitSpot] = []
	for spot in chosen_targets:
		var p := spot.party_position
		var units := spot.party.get_units_at_positions([p-1, p+1], false)
		for unit in units:
			result.append(unit.spot)
	return result
