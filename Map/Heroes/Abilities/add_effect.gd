extends HeroAbility

@export_file_path("*.gd") var effect_path: String

func _learn(hero: HeroData) -> void:
	if not FileAccess.file_exists(effect_path):
		push_error("File '%s' does not exist" % effect_path)
		return
	var s: Script = load(effect_path)
	var node := Node.new()
	node.set_script(s)
	hero.add_child(node)
