extends AuraEffect

@export var armor_increase: int = 5

const BUFF_ICON_INDEX = 5

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
			&"parameter" : "Armor",
			&"turns" : -1,
			&"strength" : armor_increase,
		},
		false,  # force_stackability
		false,  # override_stackability
		true    # silent
	)
	if not eff:
		GlobalLogger.force_message("Unable to apply the temporary", self)
		push_error("Unable to apply the effect")
		return
	eff.silencable = false
	eff.liftable = false
	_added_effects[unit] = eff
	unit.update_visuals()

func _get_description() -> String:
	return description % armor_increase

func read_params(params: Variant) -> void:
	if params is not int:
		return
	armor_increase = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.armor_increase
	return armor_increase

#func _apply_effect(params: Variant) -> void:
	#var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	#for unit in affected_units:
		#unit.display_effect_icon(ICONS.get_layer_data(BUFF_ICON_INDEX), self)
		#unit.parameters.add_modifier(
				#"armor", 
				#self, 
				#func(armor: int) -> int: return armor + armor_increase
		#)
