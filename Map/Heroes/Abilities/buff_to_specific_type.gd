extends HeroAbility

@export_file_path("*.gd") var effect_path: String = "buff_to_specific_type"
@export var stat: PartyEffectFromUnit.StatBuff
@export var stat_increase := 0
@export var stat_multiplier := 1.0
@export var type: GlobalDefs.UnitType = GlobalDefs.UnitType.Undefined

func _learn(hero: HeroData) -> void:
	var effect_args := [
		stat,
		stat_increase,
		stat_multiplier,
		type,
	]
	var serialized_effect := {effect_path: effect_args}
	MapUnitEffect.apply_serialized(serialized_effect, hero)
