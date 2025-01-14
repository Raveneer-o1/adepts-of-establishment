extends AppliedEffect

@export var armor_increase: int = 5

const BUFF_ICON_INDEX = 5

func _get_description() -> String:
	return description % armor_increase


## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	for unit in affected_units:
		unit.display_effect_icon(ICONS.get_layer_data(BUFF_ICON_INDEX), self)
		unit.parameters.add_modifier(
				"armor", 
				self, 
				func(armor: int) -> int: return armor + armor_increase
		)
