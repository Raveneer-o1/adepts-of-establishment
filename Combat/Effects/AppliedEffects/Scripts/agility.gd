extends AppliedEffect

@export var buff: float
@export var turns: int = 2

func _get_description() -> String:
	var percent: int = (
		round((buff - 1.0) * 100) if buff > 1.0 else 0
	)
	return description % percent


func trigger_effect(unit: Unit, attack: Attack) -> void:
	if unit != target_unit:
		return
	
	var params: Dictionary = {
		"parameter": &"Attack",
		"turns": turns,
		"multiplier": buff
	}
	target_unit.parameters.apply_effect("temporary_buff", params)

func read_params(params: Variant) -> void:
	if params is not Array:
		return
	if params.size() != 2:
		return
	turns = params[0]
	buff = params[1]

func _get_full_data() -> Variant:
	return [turns, buff]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.attack_evaded] = trigger_effect
