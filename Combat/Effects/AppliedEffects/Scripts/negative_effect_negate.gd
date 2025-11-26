extends AppliedEffect

@export var message: String = "Negation"

@export var triggers: int = 1

func check_trigger(e: AppliedEffect) -> void:
	if not e.negative_effect: return
	if e.target_unit != target_unit: return
	e.queue_free()
	target_unit.system.display_text_near_unit_async(target_unit, message, color_effect)
	triggers -= 1
	if triggers <= 0: lift_effect()

func read_params(params: Variant) -> void:
	if params is not int: return
	triggers = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.triggers
	return triggers

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.effect_applied] = check_trigger
