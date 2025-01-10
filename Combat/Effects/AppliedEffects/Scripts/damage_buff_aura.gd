extends AppliedEffect

@export var damage_increase: int = 5

const BUFF_ICON_INDEX = 5

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	for unit in affected_units:
		unit.display_effect_icon(ICONS.get_layer_data(BUFF_ICON_INDEX), self)
		unit.parameters.add_modifier(
				"damage", 
				self, 
				func(damage): return damage + damage_increase
		)
