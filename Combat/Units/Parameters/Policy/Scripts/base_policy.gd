extends Resource
class_name BasePolicy

## Wrapper that filters invalid input
func apply_policy(attack: Attack, finalize: bool) -> void:
	if not attack: return
	if attack.target_references.is_empty():
		return
	
	_apply_policy(attack, finalize)


func _apply_policy(attack: Attack, finalize: bool) -> void:
	# Override this method in derived classes to implement custom attack resolution logic.
	# Called once within Attack.resolve() and expected to fully resolve the attack.
	# For policies that only modify damage values without changing behavior,
	# set attack.damages dictionary and call attack.standard_resolution()
	pass
