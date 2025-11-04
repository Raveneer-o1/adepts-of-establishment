extends AppliedEffect

@export var message: String = "Provoked"

var targets: Array[UnitSpot] = []
var number_of_attacks: int:
	get: return targets.size()

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description % number_of_attacks

func check_trigger(attack: Attack) -> void:
	if attack.attacker != target_unit: return
	attack.deep_redirect(targets.pop_front())
	attack.attacker.system.display_text_near_unit_async(attack.attacker, message, color_effect)
	
	if not targets: queue_free()

func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to implement the effect's application logic.
	# Do not connect to signals manually - this is handled automatically via the 
	# _signal_function_pairs dictionary.
	if params is not Array:
		push_error(
			"Unexpected type passed to 'forced_attack'. Expected Array, got %s" % \
			type_string( typeof(params) )
		)
		queue_free()
		return
	targets.assign(params as Array)
	_signal_function_pairs[EventBus.attack_booked] = check_trigger

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
