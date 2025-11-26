extends AppliedEffect

@export var turns: int = -1

# store the effects silenced by this particular silence
var silenced_effects: Array[AppliedEffect] = []

func read_params(params: Variant) -> void:
	if params is int:
		turns = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.turns
	return turns

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	for node in get_parent().get_children():
		if node == self:
			continue
		if node is AppliedEffect:
			silenced_effects.append(node)
			node.silence_effect(turns)
	
	if turns >= 0:
		_signal_function_pairs[EventBus.turn_started] = count_turn


func count_turn(unit: Unit) -> void:
	if unit == target_unit:
		if turns <= 0:
			lift_effect()
		turns -= 1

## Internal cleanup when the effect is removed.
func _remove_effect() -> void:
	for effect in silenced_effects:
		effect.restore_effect()
