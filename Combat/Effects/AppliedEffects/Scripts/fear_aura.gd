extends AppliedEffect

@export var evasion_decrease: float = 0.01

const DEBUFF_ICON_INDEX = 6

func _get_description() -> String:
	return description % evasion_decrease

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	var pos := target_unit.party_position
	var affected_units := \
			target_unit.party.get_adjacent_units(pos)
	
	# if unit is in front line, append units of another party as well
	if pos % 2 == 0:
		var adjacent_units_from_another_party := \
			target_unit.party.other_party.get_units_at_positions(
				[pos, pos - 2,  pos +2], # step of 2 indicates adjacent units in the same row *see Party class documentation*
				false # we don't need nulls for out-of-bounds positions
			)
		affected_units.append_array(adjacent_units_from_another_party)
	
	for affected_unit in affected_units:
		affected_unit.parameters.add_modifier(
			&"evasion", 
			self, 
			func(val: int) -> int: return val - evasion_decrease
		)
		affected_unit.display_effect_icon(ICONS.get_layer_data(DEBUFF_ICON_INDEX), self)
