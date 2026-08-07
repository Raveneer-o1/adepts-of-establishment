extends AuraEffect

## Multiplier applied to the target's evasion chance.
## Should be less than [code]1.0[/code].
@export var evasion_decrease: float = 0.5

var _added_effects: Dictionary[Unit, AppliedEffect] = {}

func _remove_from(pos: int) -> void:
	var spot := get_unit_spot(pos)
	if not spot: return
	var unit := spot.unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects.erase(unit)
	unit.update_visuals()

func _apply_to(pos: int) -> void:
	var spot := get_unit_spot(pos)
	if not spot: return
	var unit := spot.unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects[unit] = null
	var eff := unit.parameters.apply_effect(
		"temporary_debuff",
		{
			&"parameter" : "Evasion",
			&"turns" : -1,
			&"multiplier" : evasion_decrease,
		},
		false,  # force_stackability
		false,  # override_stackability
		true    # silent
	)
	if not eff:
		GlobalLogger.force_message("Unable to apply the temporary effect", self)
		push_error("Unable to apply the effect")
		return
	eff.silencable = false
	eff.liftable = false
	_added_effects[unit] = eff
	unit.update_visuals()

func read_params(params: Variant) -> void:
	if params is not float: return
	evasion_decrease = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.evasion_decrease
	return evasion_decrease

func _get_affected_positions(relative_to: int = target_unit.party_position) -> Array[int]:
	var affected_positions: Array[int] = [
		relative_to - 2,
		relative_to - 1,
		relative_to + 1,
		relative_to + 2,
	]
	# if unit is in front line, append units of another party as well
	if not Party.is_front_line(relative_to): return affected_positions
	
	var adjacent_units := target_unit.party.other_party.get_units_at_positions(
		# step of 2 indicates adjacent units in the same row (see Party class documentation)
		[
			relative_to, 
			relative_to - 2, 
			relative_to + 2
		], 
		# don't need nulls for out-of-bounds positions
		false 
	)
	
	for u in adjacent_units:
		affected_positions.append( encode_spot(u.spot) )
	return affected_positions
