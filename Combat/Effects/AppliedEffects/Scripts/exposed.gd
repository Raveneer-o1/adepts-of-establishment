extends AppliedEffect

@export var turns: int = -1

func count_down(u: Unit) -> void:
	if u != target_unit: return
	turns -= 1
	if turns <= 0:
		queue_free()

func read_params(params: Variant) -> void:
	if params is not int: return
	turns = params

func _get_full_data() -> Variant:
	return turns

func _apply_effect(params: Variant) -> void:
	read_params(params)
	if turns > 0: _signal_function_pairs[EventBus.turn_started] = count_down
	target_unit.parameters.add_modifier(&"armor", self, func (v: float) -> float: return 0.0)
	
