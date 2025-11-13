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

func _apply_effect(params: Variant) -> void:
	if params is int:
		turns = params
	if params is GlobalDefs.AttackType:
		type = params
	if params is Array:
		if params.size() != 2:
			push_error("Unexpected numer of parameters! Need 2, got %d" % params.size())
			queue_free()
			return
		type = params[0]
		turns = params[1]
	
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
