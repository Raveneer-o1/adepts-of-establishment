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

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.damage_taken] = check_tigger
