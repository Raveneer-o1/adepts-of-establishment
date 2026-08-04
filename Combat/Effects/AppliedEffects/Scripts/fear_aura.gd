extends AuraEffect

@export var evasion_decrease: float = 0.01

const DEBUFF_ICON_INDEX = 6

var _added_effects: Dictionary[Unit, AppliedEffect] = {}

func _remove_from(pos: int) -> void:
	var unit := target_unit.party.unit_spots[pos].unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects.erase(unit)
	unit.update_visuals()

func _apply_to(pos: int) -> void:
	var unit := target_unit.party.unit_spots[pos].unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects[unit] = null
	var eff := unit.parameters.apply_effect(
		"temporary_buff",
		{
			&"parameter" : "Evasion",
			&"turns" : -1,
			&"strength" : -evasion_decrease,
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
	var pos := target_unit.party_position
	var affected_units := \
			target_unit.party.get_adjacent_units(pos)
	
	# if unit is in front line, append units of another party as well
	if pos % 2 == 0:
		var adjacent_units_from_another_party := \
			target_unit.party.other_party.get_units_at_positions(
				# step of 2 indicates adjacent units in the same row (see Party class documentation)
				[pos, pos - 2, pos + 2], 
				# don't need nulls for out-of-bounds positions
				false 
			)
		affected_units.append_array(adjacent_units_from_another_party)
	
	for affected_unit in affected_units:
		affected_unit.parameters.add_modifier(
			&"evasion", 
			self, 
			func(val: float) -> float: return val - evasion_decrease
		)
		affected_unit.display_effect_icon(ICONS.get_layer_data(DEBUFF_ICON_INDEX), self)
	
	var result: Array[int] = []
	for unit in affected_units:
		result.append(unit.party_position)
	return result
