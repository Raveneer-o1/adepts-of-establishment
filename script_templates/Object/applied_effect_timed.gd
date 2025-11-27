extends AppliedEffect

@export var turns: int = -1
#@export var value: int = -1

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

func read_params(params: Variant) -> void:
	const arg_number = 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		turns = params[0]
		# value = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	# Override this method to return the exact arguments needed to reconstruct a
	# copy of this effect. For example, if your effect accepts an Array as params
	# and writes it in two variables "value1" and "value2",
	# this method should return [value1, value2]
	
	# Although serialization doesn't preserve object references, this method must
	# return valid references for all objects the effect requires
	
	# if "other_effect" is specified, method should return the exact same structure
	# but with values fetched from "other_effect" 
	# (e.g. [other_effect.value1, other_effect.value2])
	return [
		turns,
		# value,
	]

func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to implement the effect's application logic.
	# Do not connect to signals manually - this is handled automatically via the 
	# _signal_function_pairs dictionary.
	
	# "params" accepts any data type (typically Array or Dictionary) required by the effect.
	# Since effects must be serializable, object references passed as arguments will
	# become null during serialization.
	
	# Effects must handle null references gracefully. When passing objects, either:
	# Serialize the object into a structure (e.g., Dictionary) instead of passing direct references
	# Or:
	# * Ensure the effect logic properly handles null reference cases
	
	# UnitAttack objects are an exception to this rule as they can be
	# automatically serialized but deserialization is.
	# See retaliation effect as an example.
	
	# For one-time effects, remove them here using queue_free().
	# See the "Cure" effect implementation as a reference example.
	
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
