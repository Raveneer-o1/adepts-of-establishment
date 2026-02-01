extends PartyEffectFromUnit

@export var armor_increase := 0

func _modify_list(list: Array[UnitData]) -> void:
	for data in list:
		data.armor += armor_increase

func _set_unit_data(list: Array[UnitData]) -> void:
	_modify_list(list)

func _apply_effect(...args: Array) -> void:
	for a: Variant in args:
		if a is int: armor_increase = args[0]
		elif a is Array:
			_apply_effect.callv(a)
			return
	effect_mapping[party_parameters.this_party.units_container.units_requested] = _set_unit_data
