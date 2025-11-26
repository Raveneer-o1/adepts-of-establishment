extends AppliedEffect

## number of times this effect cat trigger before expiring
@export var triggers: int = 1
@export var reset_hp_to: int = 1
@export var message: String = "Cheat death!"

func _get_description() -> String:
	return description %[reset_hp_to, triggers]

func check_tigger(u: Unit, dmg: int) -> void:
	if not u.parameters.dead: return
	if u != target_unit: return
	if triggers <= 0:
		if not is_queued_for_deletion():
			queue_free()
		return
	
	u.parameters.hp = reset_hp_to
	u.parameters.dead = false
	u.system.display_text_near_unit_async(u, message, color_effect)
	
	triggers -= 1
	if triggers <= 0: queue_free()

func read_params(params: Variant) -> void:
	if params is not Array[int]: return
	if params.size() != 2: return
	triggers = params[0]
	reset_hp_to = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.triggers, other_effect.reset_hp_to]
	return [triggers, reset_hp_to]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.damage_taken] = check_tigger
