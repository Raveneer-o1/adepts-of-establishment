extends AppliedEffect

@export var turns: int = 1
@export var type: GlobalDefs.AttackType = GlobalDefs.AttackType.Physical

func _get_description() -> String:
	var res := description % str(GlobalDefs.AttackType.keys()[type])
	if turns > 0:
		res += " for %d turns" % turns
	return res

func check_turn(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	turns -= 1
	if turns <= 0: lift_effect()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	type = params[0]
	turns = params[1]

func _get_full_data() -> Variant:
	return [type, turns]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	if turns == 0:
		queue_free()
		return
	target_unit.parameters.add_modifier(
		&"immunity",
		self,
		func (a: Array[GlobalDefs.AttackType]) -> Array[GlobalDefs.AttackType]:
			a.append(type)
			return a
	)
	if turns > 0:
		_signal_function_pairs[EventBus.turn_started] = check_turn
