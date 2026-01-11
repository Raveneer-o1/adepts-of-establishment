extends HeroAbility

## This ability has no validation. If you provide non-effect script,
## the node will still be instantiated and added to the [HeroData] node.
@export_file_path("*.gd") var effect_path: String
@export var effect_args: Variant = null

func _learn(hero: HeroData) -> void:
	var serialized_effect := {effect_path: effect_args}
	MapUnitEffect.apply_serialized(serialized_effect, hero)
