extends AppliedEffect

@export var turns: int = 1

@export var message_start: String = "Stunned!"
@export var message_skip: String = "Skip turn!"
@export var message_end: String = "Stun ended!"

func skip_turn(unit: Unit) -> void:
	if unit == target_unit:
		turns -= 1
		if turns <= 0:
			target_unit.animation_handle.play()
			target_unit.skip_attack(message_end)
			lift_effect()
		else:
			target_unit.skip_attack(message_skip)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is Array:
		if params.size() >= 2:
			var chance = randf()
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
	EventBus.turn_started.connect(skip_turn)
	target_unit.system.display_text_near_unit(target_unit, message_start)
	target_unit.animation_handle.pause()
