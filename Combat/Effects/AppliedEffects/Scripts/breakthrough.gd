extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

@export var shielding_chance_multiplier := 0.5

func check_defend_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if not target_unit.defense_stance: return
	if target_unit not in a.targets: return
	for u in target_unit.party.get_adjacent_units(target_unit.party_position):
		if not u: continue
		u.heal(a.damage_dealt.get(target_unit, 0))

func check_shield_trigger(a: Attack, u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u == target_unit: return
	var ref := a.find_reference(u.spot)
	assert(ref)
	if a.damages.has(ref):
		a.damages[ref] *= 2
	else: a.damages[ref] = a.default_damage * 2

func read_params(params: Variant) -> void:
	if params is float:
		shielding_chance_multiplier = params

func decrease_shielding() -> void:
	for u in target_unit.party.other_party.units:
		u.parameters.add_modifier(
			&"shielding_chance",
			self,
			func(s: float) -> float: return s * shielding_chance_multiplier
		)


func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.shielding_chance_multiplier
	return shielding_chance_multiplier

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	decrease_shielding()
	_signal_function_pairs[EventBus.attack_shielded] = check_shield_trigger
	_signal_function_pairs[EventBus.attack_resolved] = check_defend_trigger
	

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
