extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	return chosen_targets.duplicate()
