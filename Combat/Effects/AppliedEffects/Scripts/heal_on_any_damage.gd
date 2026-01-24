extends AppliedEffect

@export var percentage: float = 0.1

func _get_description() -> String:
	return description % int(percentage * 100)

func check_trigger(unit: Unit, dmg: int, flags: Array[StringName]) -> void:
	if is_queued_for_deletion(): return
	if unit == target_unit: return
	# ceiling makes the unit restore at least 1 hp
	target_unit.heal(ceili(dmg * percentage))

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.percentage
	return percentage

func read_params(params: Variant) -> void:
	if params is float:
		percentage = params

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.damage_taken] = check_trigger
