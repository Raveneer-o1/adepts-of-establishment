extends AppliedEffect

@export var turns := 2
@export var multiplier := 1.3

func trigger(attack: Attack) -> void:
	if attack.type != GlobalDefs.AttackType.Mind:
		return
	if attack.targets.has(target_unit):
		target_unit.parameters.apply_effect(
			"temporary_buff", 
			{
				"parameter" = "Attack",
				"multiplier" = multiplier,
				"turns" = turns,
			}
		)

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	turns = params[0]
	multiplier = params[1]

func _get_full_data() -> Variant:
	return [turns, multiplier]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.attack_booked] = trigger
