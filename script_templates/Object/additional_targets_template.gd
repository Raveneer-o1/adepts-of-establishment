extends BaseAdditionalTargets

func _max_number_of_targets(attack: UnitAttack) -> int:
	return 5

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	return []
