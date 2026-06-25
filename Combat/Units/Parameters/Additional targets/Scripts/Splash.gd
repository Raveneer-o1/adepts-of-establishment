extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	if chosen_targets.is_empty():
		return []
	
	var result_units := chosen_targets[0].party. \
		get_adjacent_units(chosen_targets[0].party_position)
	var result: Array[UnitSpot] = []
	for unit in result_units:
		result.append(unit.spot)
	return result

func _max_number_of_targets(attack: UnitAttack) -> int:
	# TODO: account for the fact that the target party might not have all
	# five units adjacent to each other
	return attack.targets_needed * 5
