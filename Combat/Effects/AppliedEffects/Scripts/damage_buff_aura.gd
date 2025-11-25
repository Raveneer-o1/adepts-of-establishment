extends AppliedEffect

@export var damage_increase: int = 5

const BUFF_ICON_INDEX = 5

func _get_description() -> String:
	return description % damage_increase

func read_params(params: Variant) -> void:
	if params is not int: return
	damage_increase = params

func _get_full_data() -> Variant:
	return damage_increase

func _apply_effect(params: Variant) -> void:
	read_params(params)
	var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	for unit in affected_units:
		unit.display_effect_icon(ICONS.get_layer_data(BUFF_ICON_INDEX), self)
		unit.parameters.add_modifier(
				&"base_damage", 
				self, 
				func(damage: int) -> int: return damage + damage_increase
		)
