extends AppliedEffect

@export var rounds: int = 1
@export var type: GlobalDefs.AttackType = GlobalDefs.AttackType.Physical

func _get_description() -> String:
	var res := description % str(GlobalDefs.AttackType.keys()[type])
	if rounds > 0:
		res += " for %d rounds" % rounds
	return res

func check_turn() -> void:
	if is_queued_for_deletion(): return
	rounds -= 1
	if rounds <= 0: lift_effect()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	type = params[0]
	rounds = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.type, other_effect.rounds]
	return [type, rounds]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	if rounds == 0:
		queue_free()
		return
	target_unit.parameters.add_modifier(
		&"immunity",
		self,
		func (a: Array[GlobalDefs.AttackType]) -> Array[GlobalDefs.AttackType]:
			a.append(type)
			return a
	)
	if rounds > 0:
		_signal_function_pairs[EventBus.round_ended] = check_turn
