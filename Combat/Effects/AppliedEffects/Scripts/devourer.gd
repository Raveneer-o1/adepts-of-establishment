extends AppliedEffect

@export var health_restore: int = 30

func _get_description() -> String:
	return description % health_restore


func check_trigger(unit: Unit, killer: Unit) -> void:
	if killer != target_unit:
		return
	
	target_unit.heal(health_restore)

func read_params(params: Variant) -> void:
	if params is not int: return
	health_restore = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.health_restore
	return health_restore

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.unit_killed] = check_trigger
