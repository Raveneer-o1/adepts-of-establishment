extends AppliedEffect

@export var turns: int = -1

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	if turns > 0:
		return description + " for %d turns" % turns
	return description

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return

func count_turn(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	turns -= 1
	if turns <= 0: lift_effect()

func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to implement the effect's application logic.
	# Do not connect to signals manually - this is handled automatically via the 
	# _signal_function_pairs dictionary.
	
	# For one-time effects, remove them here using queue_free().
	# See the "Cure" effect implementation as a reference example.
	var arg_number := 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		turns = params[0]
		# param = params[1]
	if turns == 0:
		lift_effect()
		return
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
	if turns > 0:
		_signal_function_pairs[EventBus.turn_ended] = count_turn

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
