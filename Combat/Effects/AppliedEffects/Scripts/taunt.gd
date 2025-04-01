extends AppliedEffect

@export var chance_to_taunt: float = 0.1

@export var message: String = "Taunted!"

func check_trigger(attack: Attack) -> void:
	if attack == null:
		return
	
	# filter cases when unit can't be a target of the attack
	if not attack.validation._validate_target(attack.attacker, target_unit.spot):
		return
	
	# filter cases when there's no point in redirecting
	# (e.g. when the attack is already targeted at this unit)
	if attack.redirected:
		return
	var target_index: UnitSpotReference = null
	for target: UnitSpotReference in attack.damages:
		if target.spot.unit == target_unit:
			continue
		target_index = target
		break
	
	if target_index == null:
		return
	
	# if random check didn't pass, don't trigger the effect
	if randf() > chance_to_taunt:
		return
	
	attack.redirect_to(target_index, target_unit)
	
	target_unit.system.display_text_near_unit(target_unit, message, color_effect)

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
