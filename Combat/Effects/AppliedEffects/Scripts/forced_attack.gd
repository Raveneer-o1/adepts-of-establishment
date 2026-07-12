extends AppliedEffect

@export var message: String = "Provoked"
@export var damage_reduction: float = 1.0

var targets: Array[UnitSpot] = []
var number_of_attacks: int:
	get: return targets.size()

func _get_description() -> String:
	return description % number_of_attacks

func check_trigger(attack: Attack) -> void:
	if attack.attacker != target_unit: return
	var redirect_to: UnitSpot = targets.pop_front()
	attack.deep_redirect(redirect_to)
	var rto_refs: Array[UnitSpotReference] = attack.find_all_references(redirect_to)
	for rto_ref in rto_refs:
		if attack.damages.has(rto_ref):
			@warning_ignore("narrowing_conversion")
			attack.damages[rto_ref] *= damage_reduction
		else:
			attack.damages[rto_ref] = roundi(attack.default_damage * damage_reduction)
	
	attack.attacker.system.display_text_near_unit_async(attack.attacker, message, color_effect)
	
	if not targets: queue_free()

func read_params(params: Variant) -> void:
	if params is not Array: return
	targets.assign(params as Array)

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.targets
	return targets

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
