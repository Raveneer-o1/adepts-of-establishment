extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description % copies

## Number of copies of positive effects applied to this unit.
@export var copies: int = -1

func check_trigger(e: AppliedEffect) -> void:
	if is_queued_for_deletion(): return
	if not e or e.is_queued_for_deletion(): return
	if e.negative_effect: return
	if e.target_unit != target_unit: return
	
	# get_full_data() returns a dictionary
	var serialized_effect: Dictionary = e.get_full_data()
	target_unit.parameters.apply_effect_path(
		serialized_effect["effect_path"],
		serialized_effect["args"],
		false,  # force_stackability
		false,  # override_stackability
		true    # silent
	)

func read_params(params: Variant) -> void:
	const arg_number = 1
	if params is not int:
		push_error("Unxepected type of agrument passed to %s! Expected int, got %d" % \
			[effect_name, type_string(typeof(params))]
		)
		queue_free()
		return
	copies = params

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
	if other_effect: return other_effect.copies
	return copies

func _apply_effect(params: Variant) -> void:
	read_params(params)
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
	
	_signal_function_pairs[EventBus.effect_applied] = check_trigger

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
