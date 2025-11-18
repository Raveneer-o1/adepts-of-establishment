extends Node2D

const PRESAVED_PATH = "res://Party_composition.tscn"
const DEFAULT_PATH = "res://Menu/Scenes/menu.tscn"


func _process(delta: float) -> void:
	if OS.is_debug_build() and FileAccess.file_exists(PRESAVED_PATH):
		get_tree().change_scene_to_file(PRESAVED_PATH)
		return
	
	get_tree().change_scene_to_file(DEFAULT_PATH)
	
