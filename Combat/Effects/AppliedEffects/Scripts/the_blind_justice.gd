extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description % int(percentage * 100)

@export var percentage: float = 1./3.
@export var message: String

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	for target in a.damage_dealt:
		var dmg_dealt := a.damage_dealt[target]
		if dmg_dealt > target.parameters.hp * percentage:
			a.attacker.take_direct_damage(dmg_dealt, message, color_effect)

func read_params(params: Variant) -> void:
	if params == null: return
	if params is not float:
		push_error(
			"Unxepected type of agrument passed to %s! Expected float, got %s" % \
			[effect_name, type_string(typeof(params))]
		)
		queue_free()
	percentage = params[0]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.percentage
	return percentage

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	_signal_function_pairs[EventBus.attack_resolved] = check_trigger
