extends AppliedEffect

@export var strength: float = 1.2

@export var message: String = "Retaliation"

func _get_description() -> String:
	return description % roundi((strength - 1) * 100) + "%"

func check_trigger(e: AppliedEffect) -> void:
	if e.target_unit != target_unit: return
	if e == self: return
	if not e.negative_effect: return
	
	if target_unit.parameters.apply_effect(
		"temporary_buff", 
		{
			"parameter" = "Attack",
			"multiplier" = strength,
			"turns" = -1,
		},
		true,  # force stackability
		true  # override stackability
	):
		target_unit.system.display_text_near_unit_async(target_unit, message, color_effect)

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.effect_applied] = check_trigger

#func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	#pass
