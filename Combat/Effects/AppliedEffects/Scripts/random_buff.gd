extends AppliedEffect

const PARAMETERS = [
	"Health",
	"Attack",
	"Armor",
]

const TEMP_BUFF_EFFECT_NAME = "temporary_buff"

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is Array:
		if params.size() == 3:
			var turns: int = params[0]
			var strength: int = params[1]
			var multiplier: float = params[2]
			var parameter: String = PARAMETERS.pick_random()
			
			target_unit.parameters.apply_effect(TEMP_BUFF_EFFECT_NAME,
				{
					"parameter" = parameter,
					"strength" = strength,
					"multiplier" = multiplier,
					"turns" = turns
				}
			)
		else:
			print_debug("Invalid number parameter for '%s' effect. Expected 3, found %d!" \
			% [ effect_name, params.size() ] )
	else:
		print_debug("Invalid parameter for '%s' effect. Expected array, found %s!" \
		% [ effect_name, type_string(typeof(params)) ] )
	
	# After temporary effect is applied, remove this effect
	queue_free()
