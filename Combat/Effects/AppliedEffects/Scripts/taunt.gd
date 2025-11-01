extends AppliedEffect

@export var chance_to_taunt: float = 0.1

@export var message: String = "Taunted!"

func check_trigger(attack: Attack) -> void:
	if attack == null:
		return
	
	if not attack.validation._validate_target(attack.attacker, target_unit.spot):
		return
	if attack.redirected:
		return
	
	var triggered: bool = false
	for target: UnitSpotReference in attack.target_references:
		if target.spot.unit == target_unit:
			continue
		if randf() > chance_to_taunt:
			continue
		attack.redirect_to(target, target_unit.spot)
		triggered = true
	
	if triggered:
		target_unit.system.display_text_near_unit(target_unit, message, color_effect)

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
