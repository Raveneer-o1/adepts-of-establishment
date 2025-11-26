extends AppliedEffect

@export var evasion_decrease: float = 0.0
@export var turns: int = 1

func _get_description() -> String:
	if turns > 0:
		return description + " for %d turns" % turns
	return description

func check_turn(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	turns -= 1
	if turns <= 0: lift_effect()

func read_params(params: Variant) -> void:
	if params is not Array[int]: return
	if params.size() != 2: return
	evasion_decrease = params[0]
	turns = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.evasion_decrease, other_effect.turns]
	return [evasion_decrease, turns]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	if turns == 0:
		lift_effect()
		return
	target_unit.parameters.add_modifier(
		&"evasion",
		self,
		func (v: float) -> float:
			return v - evasion_decrease
	)
	if turns > 0:
		_signal_function_pairs[EventBus.turn_started] = check_turn
