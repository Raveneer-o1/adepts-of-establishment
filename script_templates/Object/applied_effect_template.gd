extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return


func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to implement the effect's application logic.
	# Do not connect to signals manually - this is handled automatically via the 
	# _signal_function_pairs dictionary.
	
	# For one-time effects, remove them here using queue_free().
	# See the "Cure" effect implementation as a reference example.
	if params is not Array:
		push_error("Unxepected type passed to %s! Expected Array, got %s" % \
			[effect_name, type_string(typeof(params))]
		)
		queue_free()
		return
	_signal_function_pairs[EventBus.attack_booked] = check_trigger

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
