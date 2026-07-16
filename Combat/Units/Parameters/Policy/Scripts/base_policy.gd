@abstract
extends Resource
class_name BasePolicy

## Wrapper that filters invalid input
func apply_policy(attack: Attack, finalize: bool) -> void:
	if not attack: return
	if attack.target_references.is_empty():
		return  # why?
	
	GlobalLogger.add_message("Policy is being applied", self)
	
	_apply_policy(attack, finalize)


@abstract func _apply_policy(attack: Attack, finalize: bool) -> void
# Override this method in derived classes to implement custom attack resolution logic.
# Called once within Attack.resolve() and expected to fully resolve the attack.
# For policies that only modify damage values without changing behavior,
# set attack.damages dictionary and call attack.standard_resolution()

## Returns the maximum possible damage output of the given [param attack].[br][br]
## By default, this is computed as the attack's damage multiplied by the maximum
## number of targets it can affect (assuming equal damage to each).[br][br]
## Policies with more complex damage distribution should override this method
## to provide more accurate results.[br]
## Does account for accuracy.[br]
## Does not account for random deviations.[br]
## This method assumes that the attack has this resource set as its
## [member UnitAttack.damage_policy], but does not verify this condition.
func get_full_damage_potential(attack: UnitAttack) -> float:
	assert(attack, "Null attack detected")
	return \
		attack.expected_targets() * \
		attack.get_actual_damage() * \
		clampf(attack.accuracy, 0.0, 1.0)
