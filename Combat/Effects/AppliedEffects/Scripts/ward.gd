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
	return description % str(GlobalDefs.AttackType.keys()[damage_type])

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
