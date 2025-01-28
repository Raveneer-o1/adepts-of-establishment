extends AppliedEffect
class_name Electified

@export var turns: int = 1
@export var damage: int = 0

@export var message_start: String = "Electified!"
@export var message_trigger: String = "Shock"

func _get_description() -> String:
	return description % [turns, damage]


func count_turn(unit: Unit) -> void:
	if unit != target_unit:
		return
	turns -= 1
	if turns <= 0:
		target_unit.animation_handle.play()
		lift_effect()


func check_trigger(attack: Attack) -> void:
	if not attack.targets.has(target_unit):
		return
	
	target_unit.take_direct_damage(damage, message_trigger, color_effect)
	lift_effect()

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is Array:
		if params.size() == 2:
			turns = params[0]
			damage = params[1]
		else:
			print_debug("Invalid number parameter for an 'electified' effect. Expected 2, found %d!" % params.size())
	else:
		print_debug("Invalid parameter for an 'electified' effect. Expected array, found %s!" % type_string(typeof(params)))
	
	if turns <= 0:
		queue_free()
		return
	
	EventBus.turn_started.connect(count_turn)
	EventBus.attack_booked.connect(check_trigger)
	target_unit.system.display_text_near_unit(target_unit, message_start, color_start)
