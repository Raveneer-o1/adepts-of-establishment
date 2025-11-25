extends AppliedEffect

@export var damage_type: GlobalDefs.AttackType = GlobalDefs.AttackType.Elemental
@export var triggers: int = 1

func check_trigger(attack: Attack) -> void:
	# double attacks and attacks with multiple copies of the same target
	# will still be blocked fully: this is intentional
	if is_queued_for_deletion(): return
	# 'None' attack type is impossible to block
	if attack.type == GlobalDefs.AttackType.None:
		return
	
	if not attack.targets.has(target_unit):
		return
	
	if attack.type == damage_type:
		target_unit.warded_attacks.append(attack)
		triggers -= 1
		if triggers <= 0:
			lift_effect()

func _get_description() -> String:
	return description % [triggers, str(GlobalDefs.AttackType.keys()[damage_type])]

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	damage_type = params[0]
	triggers = params[1]

func _get_full_data() -> Variant:
	return [damage_type, triggers]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
