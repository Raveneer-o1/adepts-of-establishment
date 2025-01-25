extends AppliedEffect



func trigger(attack: Attack) -> void:
	if attack.type != EventBus.AttackType.Mind:
		return
	if attack.targets.has(target_unit):
		target_unit.parameters.apply_effect("temporary_buff", {
			"parameter" = "Attack",
			"multiplier" = 1.3,
			"turns" = 2,
		})


func _apply_effect(params: Variant) -> void:
	EventBus.attack_booked.connect(trigger)
