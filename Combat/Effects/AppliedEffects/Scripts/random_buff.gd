extends AppliedEffect

const PARAMETERS = [
	"Health",
	"Attack",
	"Armor",
]
const TEMP_BUFF_EFFECT_NAME = "temporary_buff"

var turns: int = 1
var strength: int = 0
var multiplier: float = 1.0

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
	read_params(params)
	var parameter: String = PARAMETERS.pick_random()
	
	target_unit.parameters.apply_effect(
		TEMP_BUFF_EFFECT_NAME,
		{
			"parameter" = parameter,
			"strength" = strength,
			"multiplier" = multiplier,
			"turns" = turns
		},
		false,  # force_stackability
		false,  # override_stackability
		true    # silent
	)
	# After temporary effect is applied, remove this effect
	queue_free()
