extends Node2D

const PRESAVED_PATH = "res://Party_composition.tscn"
const DEFAULT_PATH = "res://Menu/Scenes/menu.tscn"



#func _ready() -> void:
func _process(delta: float) -> void:
	if FileAccess.file_exists(PRESAVED_PATH):
	#get_tree().create_timer(0.1).timeout.connect(func():
		get_tree().change_scene_to_file(PRESAVED_PATH)
	#)
		return
	
	#get_tree().create_timer(0.1).timeout.connect(func():
	get_tree().change_scene_to_file(DEFAULT_PATH)
	#)
	
