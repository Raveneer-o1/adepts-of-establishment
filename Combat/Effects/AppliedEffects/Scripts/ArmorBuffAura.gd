extends AppliedEffect

@export var armor_increase: int = 5

const BUFF_ICON_INDEX = 5

func _get_description() -> String:
	return description % armor_increase

func read_params(params: Variant) -> void:
	if params is not int:
		return
	armor_increase = params

func _get_full_data() -> Variant:
	return armor_increase

func _apply_effect(params: Variant) -> void:
	read_params(params)
	var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	for unit in affected_units:
		unit.display_effect_icon(ICONS.get_layer_data(BUFF_ICON_INDEX), self)
		unit.parameters.add_modifier(
				"armor", 
				self, 
				func(armor: int) -> int: return armor + armor_increase
		)
