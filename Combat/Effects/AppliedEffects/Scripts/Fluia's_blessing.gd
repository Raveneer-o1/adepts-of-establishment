extends AppliedEffect

@export var message: String = "Fluia's Blessing"

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

const TARGET_FLAG = &"hemorrhage"

func check_trigger(unit: Unit, dmg: int, flags: Array[StringName]) -> void:
	if is_queued_for_deletion(): return
	if unit == target_unit: return
	if TARGET_FLAG not in flags: return
	target_unit.heal(dmg, message)

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	return null

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.damage_taken] = check_trigger

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
