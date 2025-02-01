extends AppliedEffect
class_name Stun

@export var turns: int = 1

@export var message_start: String = "Stunned!"
@export var message_skip: String = "Skip turn!"
@export var message_end: String = "Stun ended!"

func _get_description() -> String:
	return description % turns


func skip_turn(unit: Unit) -> void:
	if unit == target_unit:
		turns -= 1
		if turns <= 0:
			target_unit.animation_handle.play()
			lift_effect()
			target_unit.skip_attack(message_end, color_effect)
		else:
			target_unit.skip_attack(message_skip, color_effect)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is Array:
		if params.size() >= 2:
			var chance := randf()
			if chance < params[0]:
				turns = params[1]
			else:
				queue_free()
				return
		else:
			print_debug("Invalid number parameter for a stun effect. Expected 2, found %d!" % params.size())
	else:
		print_debug("Invalid parameter for a stun effect. Expected Array, found %s!" % type_string(typeof(params)))
	if turns <= 0:
		queue_free()
		return
	target_unit.system.display_text_near_unit(target_unit, message_start, color_start)
	target_unit.animation_handle.pause()
	
	_signal_function_pairs[EventBus.turn_started] = skip_turn
	
