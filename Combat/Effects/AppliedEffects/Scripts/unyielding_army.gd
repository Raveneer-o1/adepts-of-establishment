extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description % [armor_increase, int((damage_multiplier - 1.0) * 100)]

@export var armor_increase := 30
@export var damage_multiplier := 1.1

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return

func read_params(params: Variant) -> void:
	const arg_number = 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		armor_increase = params[0]
		damage_multiplier = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.armor_increase, other_effect.damage_multiplier]
	return [armor_increase, damage_multiplier]

func _check_if_should_apply() -> bool:
	var i := 0
	var arr := target_unit.party.get_units_at_positions([i], true)
	while arr:
		if not arr[0]: return true
		i += 2
		arr = target_unit.party.get_units_at_positions([i], true)
	return false

func _apply_effect(params: Variant) -> void:
	for u in target_unit.party.units:
		if not u: continue
		u.parameters.add_modifier(
			&"armor",
			self,
			func(a: int) -> int:
				if not _check_if_should_apply():
					return a
				return a + armor_increase
		)
		u.parameters.add_modifier(
			&"base_damage",
			self,
			func(a: int) -> int:
				if not _check_if_should_apply():
					return a
				return ceili(a * damage_multiplier)
		)

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
	pass
