extends AppliedEffect

@export var buff: float = 1.5
@export var turns: int = 1

func check_trigger(unit: Unit, oldp: int) -> void:
	if unit != target_unit: return
	target_unit.parameters.apply_effect(
		"temporary_buff", 
		{
			"parameter" = &"Evasion",
			"multiplier" = buff,
			"turns" = turns,
		}
	)

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	buff = params[0]
	turns = params[1]

func _get_full_data() -> Variant:
	return [buff, turns]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.unit_moved] = check_trigger
