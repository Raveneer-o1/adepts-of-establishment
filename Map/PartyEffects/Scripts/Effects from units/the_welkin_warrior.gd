extends PartyEffectFromUnit

@export var armor_increase := 0

func _modify_list(list: Array[UnitData]) -> Array[UnitData]:
	for data in list:
		data.armor += armor_increase
	return list

func _set_unit_data() -> void:
	var list: Array[UnitData] = party_parameters.accumulated_value \
		if party_parameters.accumulated_value \
		else party_parameters.get_unit_list_copy()
	party_parameters.accumulated_value = _modify_list(list)

func _apply_effect(...args: Array) -> void:
	for a: Variant in args:
		if a is int: armor_increase = args[0]
		elif a is Array:
			_apply_effect.callv(a)
			return
	effect_mapping[party_parameters.unit_data_requested] = _set_unit_data
