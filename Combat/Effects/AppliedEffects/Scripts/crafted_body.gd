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


## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.unit_revived] = check_trigger
