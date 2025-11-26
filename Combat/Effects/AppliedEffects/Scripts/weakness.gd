extends AppliedEffect

var turns: int = 0
var damage_decrease: int

func _get_description() -> String:
	# Unit's damage is decreased by %d for %d turns
	return description % [damage_decrease, turns]


# Reduces the number of remaining turns and removes the effect when expired
func count_turn(unit: Unit) -> void:
	if unit == target_unit:
		turns -= 1
		if turns <= 0:
			lift_effect()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	turns = params[0]
	damage_decrease = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.turns, other_effect.damage_decrease]
	return [turns, damage_decrease]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	if turns <= 0:
		lift_effect()
		return
	
	_signal_function_pairs[EventBus.turn_started] = count_turn
	
	target_unit.parameters.add_modifier(
		&"base_damage",
		self, 
		func (damage: int) -> int:
			return damage - damage_decrease)
