extends AppliedEffect

func _get_description() -> String:
	return description % [triggers, str(GlobalDefs.AttackType.keys()[type])]

@export var type: GlobalDefs.AttackType
@export var triggers := 1

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if a.type != type: return
	var i := a.target_references.find_custom(
		func(r: UnitSpotReference) -> bool: return r.spot == target_unit.spot
	)
	if i < 0: return
	var ref := a.target_references[i]
	var dmg: int = a.damages.get(ref, a.default_damage)
	a.damages[ref] = -absi(dmg)
	triggers -= 1
	if triggers <= 0: queue_free()

func read_params(params: Variant) -> void:
	const arg_number = 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		type = params[0]
		triggers = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.type, other_effect.triggers]
	return [type, triggers]

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
