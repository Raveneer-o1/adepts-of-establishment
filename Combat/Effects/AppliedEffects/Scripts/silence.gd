extends AppliedEffect

@export var turns: int = -1

var silenced_effects: Array[AppliedEffect] = []

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is int:
		turns = params
	else:
		print_debug("Invalid parameter for a '%s' effect. Expected int, found %s!" \
				% [ effect_name, type_string(typeof(params)) ] )
		queue_free()
		return
	
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
