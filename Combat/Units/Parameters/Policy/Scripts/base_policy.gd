extends Resource
class_name BasePolicy

## Wrapper that filters invalid input (i.e. [param attack] being null, [param index] outside boundaries)
func apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	
	_apply_policy(attack, index, finalize)


func _apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	pass
