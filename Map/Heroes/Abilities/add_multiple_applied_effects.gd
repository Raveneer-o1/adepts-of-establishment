extends HeroAbility

@export_file_path("*.tscn") var effect_paths: Array[String]
@export var effect_names: Array[String]
@export var args_arr: Array

func _learn(hero: HeroData) -> void:
	var size := effect_paths.size()
	assert(effect_names.size() == size)
	assert(args_arr.size() == size)
	for i in range(size):
		var effect_path := effect_paths[i]
		assert(not effect_path.is_empty())
		assert(FileAccess.file_exists(effect_path))
		var effect_name := effect_names[i]
		var args: Variant = args_arr[i]
		hero.effects.append({
			&"effect_path": effect_path,
			&"effect_name": effect_name,
			&"args": args,
		})
