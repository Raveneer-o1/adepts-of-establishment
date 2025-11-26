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

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	turns = params[0]
	damage = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.turns, other_effect.damage]
	return [turns, damage]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	if turns <= 0:
		queue_free()
		return
	
	_signal_function_pairs[EventBus.turn_started] = count_turn
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
	
	target_unit.system.display_text_near_unit(target_unit, message_start, color_start)
