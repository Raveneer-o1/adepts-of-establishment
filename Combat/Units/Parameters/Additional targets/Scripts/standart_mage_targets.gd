extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	var all_units := attacker.party.other_party.get_units_custom(all_units_filter)
	var result: Array[UnitSpot]
	for u in all_units:
		if u.spot and not chosen_targets.has(u.spot):
			result.append(u.spot)
	return filter_duplicates(result)



func filter_duplicates(arr: Array[UnitSpot]) -> Array[UnitSpot]:
	var result: Array[UnitSpot] = []
	for u in arr:
		if not result.has(u):
			result.append(u)
	return result


func all_units_filter(unit: Unit) -> bool:
	if unit == null:
		return false
	if unit.parameters.dead:
		return false
	return true
