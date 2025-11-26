extends AppliedEffect

@export var message: String = "Adapt"
@export var change_to: GlobalDefs.AttackType

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if a.attacker != target_unit: return
	if not a.target_references: return
	var unit_to_check := a.target_references[0].spot.unit
	if not unit_to_check: return
	if unit_to_check.parameters.immunities.has(GlobalDefs.AttackType.Elemental):
		a.type = change_to

func read_params(params: Variant) -> void:
	if params is not GlobalDefs.AttackType:
		return
	change_to = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.change_to
	return change_to

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
