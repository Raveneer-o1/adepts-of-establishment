extends HeroAbility

@export_file_path("*.tscn") var effect_path: String
@export var effect_name: String
@export var args: Variant

@export var additional_uses := 1
const EFFECT_NAME = "Divine nature"

func _learn(hero: HeroData) -> void:
	assert(not effect_path.is_empty())
	assert(FileAccess.file_exists(effect_path))
	hero.effects.append({
		&"effect_path": effect_path,
		&"effect_name": effect_name,
		&"args": args,
	})
