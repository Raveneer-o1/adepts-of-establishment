extends AppliedEffect

@export var damage_type: EventBus.AttackType = EventBus.AttackType.Elemental


func trigger_effect(attack: Attack) -> void:
	if not attack.targets.has(target_unit):
		return
	
	if attack.type == damage_type:
		target_unit.shielded_attacks.append(attack)
		queue_free()

func _get_description() -> String:
	return description % str(EventBus.AttackType.keys()[damage_type])

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = trigger_effect
