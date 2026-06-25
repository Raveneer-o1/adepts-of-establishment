@abstract
extends Resource
class_name BaseAdditionalTargets

## Returns the targets automatically added by this attack's targeting logic.
## The original [param chosen_targets] are not included in the result.
@abstract func find_additional_targets(
	attacker: Unit,
	chosen_targets: Array[UnitSpot]
) -> Array[UnitSpot]

## Returns the maximum total number of targets the given [param attack] can affect,
## including both the targets manually selected by the player and any additional
## targets added by this resource.
## This method assumes that the attack has this resource set as its
## [member UnitAttack.additional_targets], but does not verify this condition.
## The result [b]can[/b] be more than [constant Party.MAX_UNITS_NUMBER]
## (e.g., if the attack hits the entire party multiple times)
func max_number_of_targets(attack: UnitAttack) -> int:
	assert(attack, "Null attack detected")
	return maxi(_max_number_of_targets(attack), 0)

@abstract func _max_number_of_targets(attack: UnitAttack) -> int
