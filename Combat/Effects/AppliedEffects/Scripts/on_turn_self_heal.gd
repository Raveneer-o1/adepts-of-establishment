extends AppliedEffect

@export var heal: int = 10

func _get_description() -> String:
	return description % heal

func check_trigger(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	u.heal(heal, "", color_effect)


func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.turn_started] = check_trigger
