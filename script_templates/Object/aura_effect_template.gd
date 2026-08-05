extends AuraEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

@export var value: int = -1

var _added_effects: Dictionary[Unit, AppliedEffect] = {}

# NOTE: _get_affected_positions() should return positive values for allies
# and negative values for enemies.
# Enemy positions should be calculated as:
# position - Party.MAX_UNITS_NUMBER
# This yields the following mapping (assuming Party.MAX_UNITS_NUMBER = 7):
# 0 <--> -7
# 1 <--> -6
# 2 <--> -5
# 3 <--> -4
# 4 <--> -3
# 5 <--> -2
# 6 <--> -1
# However, you should not compute these numbers manually — use encode_spot()
# to obtain the spot code and get_unit_spot() to retrieve the UnitSpot object.

# By default, aura effects affect all adjacent allies.
# If you need other behavior, uncomment and implemend the method below
#func _get_affected_positions(relative_to: int = target_unit.party_position) -> Array[int]:
	# Example: this aura will affect the all allies with even position
	# (i.e., the entire backline)
	#var res: Array[int] = []
	#res.assign(range(0, Party.MAX_UNITS_NUMBER, 2))
	#return res

# NOTE: _remove_from() and _apply_to() are called for each valid spot position.
# You do not need to validate that pos is within array boundaries, but it is
# not guaranteed that a unit will be present on that spot.
# This design allows aura effects to affect empty spots as needed.

# Called to remove this aura's effects when a target moves out of range
# or the aura effect is invalidated.
func _remove_from(pos: int) -> void:
	var spot := get_unit_spot(pos)
	if not spot: return
	var unit := spot.unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects.erase(unit)
	unit.update_visuals()

# Called to apply this aura's effects to a target at the given position.
func _apply_to(pos: int) -> void:
	if pos < 0: return  # if enemy
	var spot := get_unit_spot(pos)
	if not spot: return
	var unit := spot.unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects[unit] = null
	var eff := unit.parameters.apply_effect(
		"temporary_buff",
		{
			&"parameter" : "Attack",
			&"turns" : -1,
			&"strength" : value,
		},
		false,  # force_stackability
		false,  # override_stackability
		true    # silent
	)
	if not eff:
		GlobalLogger.force_message("Unable to apply the temporary effect", self)
		push_error("Unable to apply the effect")
		return
	eff.silencable = false
	eff.liftable = false
	_added_effects[unit] = eff
	unit.update_visuals()

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return

func read_params(params: Variant) -> void:
	const arg_number = 1
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		value = params[0]

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
	if other_effect: return [other_effect.value]
	return [value]

# Aura effects do not need to implement _apply_effect() themselves,
# as the base AuraEffect class handles ithe setup automatically.
# If you need custom application logic, call super._apply_effect(params).
# All other rules are the same as for regular effects (see notes below).
#func _apply_effect(params: Variant) -> void:
	#super._apply_effect(params)
	
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


func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
