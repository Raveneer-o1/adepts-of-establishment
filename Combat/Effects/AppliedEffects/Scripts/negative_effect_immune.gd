extends AppliedEffect

@export var message: String = "Immune to effects"

func  check_trigger(e: AppliedEffect) -> void:
	if not e.negative_effect: return
	if e.target_unit != target_unit: return
	e.queue_free()
	target_unit.system.display_text_near_unit_async(target_unit, message, color_effect)

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.effect_applied] = check_trigger
