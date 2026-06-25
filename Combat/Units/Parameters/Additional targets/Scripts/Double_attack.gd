extends BaseAdditionalTargets

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	return chosen_targets.duplicate()

func _max_number_of_targets(attack: UnitAttack) -> int:
	return attack.targets_needed * 2
