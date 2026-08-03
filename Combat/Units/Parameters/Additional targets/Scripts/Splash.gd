extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	if chosen_targets.is_empty():
		return []
	
	var result: Array[UnitSpot] = []
	for chosen_target in chosen_targets:
		var result_units := chosen_target.party. \
			get_adjacent_units(chosen_target.party_position)
		for unit in result_units:
			result.append(unit.spot)
	return result

func _max_number_of_targets(attack: UnitAttack) -> int:
	var n := 0
	var party := attack.unit.party.other_party
	for i in range(Party.MAX_UNITS_NUMBER):
		var targets_here := party.get_adjacent_units(i).size() + \
			(1 if party.unit_spots[i].unit else 0)
		if targets_here > n: n = targets_here
	return attack.targets_needed * n
