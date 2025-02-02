extends AppliedEffect


@export var buff_parameters := {
	"max_HP" = 15,
	"armor" = 5,
	"base_damage" = 10,
	"evasion" = 0.005
}

func _get_description() -> String:
	return description

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is Dictionary:
		buff_parameters = params
	for parameter: String in buff_parameters:
		var function := func (val: int) -> int: return val + buff_parameters[parameter]
		target_unit.parameters.add_modifier(
			parameter, 
			self,
			function
		)
