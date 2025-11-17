extends AppliedEffect

@export var message: String = "Death curse"

@export var turns: int = -1
@export var damage: int = 10

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	if turns > 0:
		return description + " for %d turns" % turns
	return description % damage

func check_trigger(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	u.take_direct_damage(damage, message, color_effect)

func count_turn(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	turns -= 1
	if turns <= 0: lift_effect()

func _apply_effect(params: Variant) -> void:
	const arg_number = 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		turns = params[0]
		damage = params[1]
	if turns == 0:
		lift_effect()
		return
	
	var eff := target_unit.parameters.find_effect(effect_name, self)
	if eff:
		eff.damage += damage
		queue_free()
		return
	
	_signal_function_pairs[EventBus.turn_started] = check_trigger
	if turns > 0:
		_signal_function_pairs[EventBus.turn_ended] = count_turn
