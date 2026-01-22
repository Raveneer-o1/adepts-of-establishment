extends HeroAbility

@export_file_path("*.gd") var effect_path: String
@export var effect_args: Variant

func _learn(hero: HeroData) -> void:
	var serialized_effect := {effect_path: effect_args}
	MapUnitEffect.apply_serialized(serialized_effect, hero)
