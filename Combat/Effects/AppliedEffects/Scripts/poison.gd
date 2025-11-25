extends AppliedEffect

@export var damage_per_turn: int = 30
@export var turns: int = 1

func _get_description() -> String:
	return description % [damage_per_turn, turns]

func deal_damage(unit: Unit) -> void:
	if unit != target_unit:
		return
	target_unit.take_direct_damage(damage_per_turn, "poison", color_effect)
	turns -= 1
	if turns <= 0:
		lift_effect()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	damage_per_turn = params[0]
	turns = params[1]

func _get_full_data() -> Variant:
	return [damage_per_turn, turns]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	_signal_function_pairs[EventBus.turn_started] = deal_damage
