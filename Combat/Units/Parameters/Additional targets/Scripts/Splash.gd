extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	if chosen_targets.is_empty():
		return []
	var result_units := attacker.party.other_party.get_adjacent_units(attacker.chosen_targets[0].party_position)
	var result: Array[UnitSpot]
	for unit in result_units:
		result.append(unit.spot)
	return result
