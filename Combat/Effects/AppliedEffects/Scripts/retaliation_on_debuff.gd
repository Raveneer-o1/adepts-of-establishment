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

func read_params(params: Variant) -> void:
	if params is not float: return
	strength = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.strength
	return strength

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.effect_applied] = check_trigger
