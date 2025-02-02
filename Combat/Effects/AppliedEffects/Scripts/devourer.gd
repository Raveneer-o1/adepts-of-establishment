extends AppliedEffect

@export var health_restore: int = 30

func _get_description() -> String:
	return description % health_restore


func check_trigger(unit: Unit, killer: Unit) -> void:
	if killer != target_unit:
		return
	
	target_unit.heal(health_restore)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.unit_killed] = check_trigger
