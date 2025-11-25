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
	if GlobalDefs.rand_roll(chance, target_unit.party.other_party): return
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

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	turns = params[0]
	chance = params[1]

func _get_full_data() -> Variant:
	return [turns, chance]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	if turns == 0:
		lift_effect()
		return
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
	if turns > 0:
		_signal_function_pairs[EventBus.turn_ended] = count_turn
