extends Resource
class_name BaseAdditionalTargets

# Number of targets added by [method find_additional_targets]
#@export var total_targets: float

func find_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	return []
