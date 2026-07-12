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

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 3: return
	turns = params[0]
	strength = params[1]
	multiplier = params[2]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [
			other_effect.turns,
			other_effect.strength,
			other_effect.multiplier
		]
	return [
		turns,
		strength,
		multiplier
	]

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.effect_applied] = check_trigger
