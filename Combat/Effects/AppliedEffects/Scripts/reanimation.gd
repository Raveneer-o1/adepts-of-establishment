extends AppliedEffect


@export var buff_parameters := {
	"max_HP" = 15,
	"armor" = 5,
	"base_damage" = 10,
	"evasion" = 0.005
}

func _get_description() -> String:
	return description

func read_params(params: Variant) -> void:
	if params is not Dictionary: return
	buff_parameters = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.buff_parameters
	return buff_parameters

func _apply_effect(params: Variant) -> void:
	read_params(params)
	for parameter: String in buff_parameters:
		#print(parameter + ": " + str(buff_parameters[parameter]))
		var function := func (val: Variant) -> Variant: return val + buff_parameters[parameter]
		target_unit.parameters.add_modifier(
			parameter, 
			self,
			function
		)
