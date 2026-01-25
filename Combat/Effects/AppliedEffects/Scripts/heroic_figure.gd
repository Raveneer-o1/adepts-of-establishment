extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

@export var xp_bonus: int = 40

func check_trigger() -> void:
	if is_queued_for_deletion(): return
	for u in target_unit.party.all_units:
		u.original_data.grant_xp(xp_bonus)
	queue_free()

func read_params(params: Variant) -> void:
	const arg_number = 1
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		xp_bonus= xp_bonus

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
	if other_effect: return other_effect.xp_bonus
	return xp_bonus

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
	
	_signal_function_pairs[EventBus.battle_ended] = check_trigger
