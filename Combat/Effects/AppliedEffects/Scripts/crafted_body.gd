extends AppliedEffect


@export var buff_parameters := {
	"max_HP" = 30,
	"armor" = 10,
	"base_damage" = 20,
	"evasion" = 0.01
}

func check_trigger(unit: Unit) -> void:
	if unit == target_unit:
		target_unit.parameters.apply_effect("reanimation", buff_parameters)


func read_params(params: Variant) -> void:
	if params is not Dictionary: return
	buff_parameters = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.buff_parameters
	return buff_parameters

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.unit_revived] = check_trigger
