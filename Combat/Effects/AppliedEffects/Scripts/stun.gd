extends AppliedEffect
class_name Stun

@export var turns: int = 1
@export var chance_to_be_lifted: float = 1.0

@export var message_start: String = "Stunned!"
@export var message_skip: String = "Skip turn!"
@export var message_end: String = "Stun ended!"

func _get_description() -> String:
	return description % turns


func skip_turn(unit: Unit) -> void:
	if unit != target_unit:
		return
	
	turns -= 1
	if turns <= 0 and GlobalDefs.rand_roll(chance_to_be_lifted, target_unit.party):
		target_unit.animation_handle.play()
		lift_effect()
	
	target_unit.skip_attack(message_skip, color_effect)

func visualize_paralysis() -> void:
	if is_queued_for_deletion(): return
	target_unit.system.display_text_near_unit(target_unit, message_start, color_start)
	target_unit.animation_handle.pause()

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	chance_to_be_lifted = params[0]
	turns = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.chance_to_be_lifted, other_effect.turns]
	return [chance_to_be_lifted, turns]

func _apply_effect(params: Variant) -> void:
	if turns <= 0:
		queue_free()
		return
	_signal_function_pairs[EventBus.turn_started] = skip_turn
	call_deferred(&"visualize_paralysis")
