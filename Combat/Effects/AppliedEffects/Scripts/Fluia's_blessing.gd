extends AppliedEffect

@export var message: String = "Fluia's blessing"

const TARGET_FLAG = &"hemorrhage"

func read_params(params: Variant) -> void:
	pass

func check_trigger(unit: Unit, dmg: int, flags: Array[StringName]) -> void:
	if is_queued_for_deletion(): return
	if unit == target_unit: return
	if TARGET_FLAG not in flags: return
	target_unit.heal(dmg, message)

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.damage_taken] = check_trigger
