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

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.unit_moved] = check_trigger
