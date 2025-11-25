extends AppliedEffect

@export var flat_increase: int = 30
@export var multiplier: float = 1.0

var effect: AppliedEffect

func count_up() -> void:
	if effect:
		effect.strength += flat_increase
		effect.multiplier *= multiplier
		effect.turns = 2
	else:
		effect = target_unit.parameters.apply_effect(
			"temporary_buff", 
			{
				"parameter" = "Attack",
				"multiplier" = multiplier,
				"strength" = flat_increase,
				"turns" = 2,
			}
		)

func reset() -> void:
	if effect:
		effect.lift_effect()

func check_trigger(attack: Attack) -> void:
	if attack.attacker != target_unit: return
	if attack.tags.has(&"missed") or attack.tags.has(&"evaded"):
		reset()
	else:
		count_up()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	flat_increase = params[0]
	multiplier = params[1]

func _get_full_data() -> Variant:
	return [flat_increase, multiplier]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.attack_resolved] = check_trigger
