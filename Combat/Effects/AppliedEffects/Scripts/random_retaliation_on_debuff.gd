extends AppliedEffect

@export var turns: int = 2
@export var strength: int = 0
@export var multiplier: float = 1.2

@export var message: String = "Retaliation"

func check_trigger(e: AppliedEffect) -> void:
	if e.target_unit != target_unit: return
	if e == self: return
	if not e.negative_effect: return
	
	if target_unit.parameters.apply_effect(
		"random_buff", 
		[
			turns,
			strength,
			multiplier,
		],
		true,  # force stackability
		true  # override stackability
	):
		target_unit.system.display_text_near_unit_async(target_unit, message, color_effect)

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.effect_applied] = check_trigger
