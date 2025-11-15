extends AppliedEffect

@export var turns: int = -1
@export var chance: float = 0.5
@export var message: String = "Confused"

func _get_description() -> String:
	if turns > 0:
		return description + " for %d turns" % turns
	return description

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if a.attacker != target_unit: return
	if not a.target_references: return
	if chance < randf(): return
	target_unit.system.display_text_near_unit_async(
		target_unit,
		message,
		color_effect
	)
	for ref in a.target_references:
		a.redirect_to(
			ref, ref.spot.party.unit_spots.filter(
				func (u: UnitSpot) -> bool: return u != null
			).pick_random()
		)

func count_turn(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	turns -= 1
	if turns <= 0: lift_effect()

func _apply_effect(params: Variant) -> void:
	var arg_number := 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		turns = params[0]
		chance = params[1]
	if turns == 0:
		lift_effect()
		return
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
	if turns > 0:
		_signal_function_pairs[EventBus.turn_ended] = count_turn
