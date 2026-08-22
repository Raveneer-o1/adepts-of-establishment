extends AppliedEffect


func read_params(params: Variant) -> void:
	pass

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	return null

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_resolved] = check_defend_trigger

func _remove_effect() -> void:
	pass

func check_defend_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if not target_unit.defense_stance: return
	if target_unit not in a.targets: return
	for u in target_unit.party.get_adjacent_units(target_unit.party_position):
		if not u: continue
		u.heal(a.damage_dealt.get(target_unit, 0))
