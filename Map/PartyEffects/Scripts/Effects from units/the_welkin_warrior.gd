extends PartyEffectFromUnit

@export var armor_increase := 10

func _modify_list(list: Array[UnitData]) -> Array[UnitData]:
	for data in list:
		data.armor += armor_increase
	return list

func _set_unit_data() -> void:
	var list: Array[UnitData] = party_parameters.accumulated_value \
		if party_parameters.accumulated_value \
		else party_parameters.get_unit_list_copy()
	party_parameters.accumulated_value = _modify_list(list)

func _apply_effect() -> void:
	effect_mapping[party_parameters.unit_data_requested] = _set_unit_data
