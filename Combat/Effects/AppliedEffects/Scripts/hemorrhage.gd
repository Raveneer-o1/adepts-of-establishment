extends AppliedEffect

@export var damage_per_turn: int = 10
@export var turns: int = -1

func _get_description() -> String:
	if turns < 0:
		return description % damage_per_turn
	return (description + " for %d turns") % [damage_per_turn, turns]

func deal_damage(unit: Unit) -> void:
	if unit != target_unit:
		return
	target_unit.take_direct_damage(
		damage_per_turn,
		"Hemorrhage",
		color_effect,
		[&"hemorrhage"]
	)
	if turns < 0: return
	turns -= 1
	if turns <= 0:
		lift_effect()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	damage_per_turn = params[0]
	turns = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.damage_per_turn, other_effect.turns]
	return [damage_per_turn, turns]

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.turn_started] = deal_damage
