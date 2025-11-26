extends AppliedEffect

@export var damage_pet_turn: int = 30
@export var turns: int = 1

func _get_description() -> String:
	return description % [damage_pet_turn, turns]

func deal_damage(unit: Unit) -> void:
	if unit != target_unit:
		return
	target_unit.take_damage(damage_pet_turn, "burn")
	turns -= 1
	if turns <= 0:
		lift_effect()

func read_params(params: Variant) -> void:
	if params is Array:
		if params.size() >= 2:
			turns = params[0]
			damage_pet_turn = params[1]
	else:
		print_debug("Invalid parameter for a burn effect. Expected Array, found %s!" % type_string(typeof(params)))

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.turns, other_effect.damage_pet_turn]
	return [turns, damage_pet_turn]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.turn_started] = deal_damage
