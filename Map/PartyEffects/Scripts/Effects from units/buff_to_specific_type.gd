extends PartyEffectFromUnit

@export var stat: PartyEffectFromUnit.StatBuff
@export var stat_increase := 0
@export var stat_multiplier := 1.0
@export var type: GlobalDefs.UnitType = GlobalDefs.UnitType.Undefined

func _modify_list(list: Array[UnitData]) -> Array[UnitData]:
	for data in list:
		if data.unit_type != type: continue
		match stat:
			PartyEffectFromUnit.StatBuff.health: data.max_hp = \
				int(data.max_hp * stat_multiplier + stat_increase)
			StatBuff.damage: data.base_damage = \
				int(data.base_damage * stat_multiplier + stat_increase)
			StatBuff.armor: data.armor = \
				int(data.armor * stat_multiplier + stat_increase)
			StatBuff.evasion: data.evasion = \
				data.evasion * stat_multiplier + stat_increase
			StatBuff.shielding_chance: data.shielding_chance = \
				data.shielding_chance * stat_multiplier + stat_increase
	return list

func _set_unit_data() -> void:
	if type == GlobalDefs.UnitType.Undefined: return
	var list: Array[UnitData] = party_parameters.accumulated_value \
		if party_parameters.accumulated_value \
		else party_parameters.get_unit_list_copy()
	party_parameters.accumulated_value = _modify_list(list)

func _apply_effect(...args: Array) -> void:
	for a: Variant in args:
		if a is GlobalDefs.UnitType:
			type = a
		elif a is int:
			stat_increase = a
		elif a is float:
			stat_multiplier = a
		elif a is Array:
			_apply_effect.callv(a)
			return
	effect_mapping[party_parameters.unit_data_requested] = _set_unit_data
