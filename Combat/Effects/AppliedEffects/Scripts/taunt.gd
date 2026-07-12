extends AppliedEffect

@export var message: String = "Taunted!"

@export var chance_to_taunt: float = 0.1
## Multiplier to damage. Can be set to value more than 1.0 to increase damage instead
@export var damage_reduction_during_taunting: float = 1.0

func check_trigger(attack: Attack) -> void:
	if attack == null:
		return
	if attack.attacker.party == target_unit.party:
		return
	if not attack.validation.validate_target(attack.attacker, target_unit.spot):
		return
	if attack.redirected:
		return
	if attack.is_primary_target(target_unit.spot):
		return
	if not GlobalDefs.rand_roll(chance_to_taunt, target_unit.party):
		return
	
	attack.deep_redirect(target_unit.spot)
	target_unit.system.display_text_near_unit(target_unit, message, color_effect)
	if is_equal_approx(damage_reduction_during_taunting, 1.0): return
	
	var for_reduction := attack.find_all_references(target_unit.spot)
	for ref: UnitSpotReference in for_reduction:
		attack.damages[ref] = int(
			damage_reduction_during_taunting * (attack.damages[ref]
			if attack.damages.has(ref) else attack.default_damage)
		)

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	chance_to_taunt = params[0]
	damage_reduction_during_taunting = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [
			other_effect.chance_to_taunt,
			other_effect.damage_reduction_during_taunting
		]
	return [chance_to_taunt, damage_reduction_during_taunting]

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
