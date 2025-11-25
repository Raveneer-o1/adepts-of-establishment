extends AppliedEffect

@export var heal: int = 25

func _get_description() -> String:
	return description % heal

func check_trigger(unit: Unit) -> void:
	if unit != target_unit: return
	for u in unit.party.get_adjacent_units(unit.party_position):
		u.heal(heal)

func read_params(params: Variant) -> void:
	if params is not int: return
	heal = params

func _get_full_data() -> Variant:
	return heal

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.turn_started] = check_trigger
