extends BaseAdditionalTargets

func _max_number_of_targets(attack: UnitAttack) -> int:
	var n := attack.targets_needed
	if Party.is_front_line(attack.unit.party_position):
		n += (attack.unit.party.other_party.get_units_at_positions(
			[
				attack.unit.party_position,
				attack.unit.party_position - 2,
				attack.unit.party_position + 2,
			],
			false
		)).size()
	return n

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	if chosen_targets.is_empty():
		return []
	
	var result: Array[UnitSpot] = []
	var result_units := attacker.party. \
		get_adjacent_units(attacker.party_position)
	if Party.is_front_line(attacker.party_position):
		result_units.append_array(attacker.party.other_party.get_units_at_positions(
			[
				attacker.party_position,
				attacker.party_position - 2,
				attacker.party_position + 2,
			],
			false
		))
	for unit in result_units:
		result.append(unit.spot)
	return result
