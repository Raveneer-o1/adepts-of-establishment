extends BaseAdditionalTargets

func _max_number_of_targets(attack: UnitAttack) -> int:
	return 3 * attack.targets_needed

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	var result: Array[UnitSpot] = []
	for spot in chosen_targets:
		result.append_array(_get_two_targets(spot))
	return result

func _get_two_targets(spot: UnitSpot) -> Array[UnitSpot]:
	var positions: Array[int] = [
		spot.party_position - 2,
		spot.party_position + 2,
	]
	var units := spot.party.get_units_at_positions(
		positions,
		false
	)
	var result: Array[UnitSpot] = []
	for unit in units:
		result.append(unit.spot)
	return result
