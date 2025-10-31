extends AppliedEffect

@export var damage_type: GlobalDefs.AttackType = GlobalDefs.AttackType.Elemental


func trigger_effect(attack: Attack) -> void:
	# 'None' attack type is impossible to block
	if attack.type == GlobalDefs.AttackType.None:
		return
	
	if not attack.targets.has(target_unit):
		return
	
	if attack.type == damage_type:
		target_unit.warded_attacks.append(attack)
		queue_free()

func _get_description() -> String:
	return description % str(GlobalDefs.AttackType.keys()[damage_type])

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = trigger_effect
