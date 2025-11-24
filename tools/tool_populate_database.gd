@tool
extends EditorScript

func _handle_file(s: String) -> void:
	#print(s)
	#return
	EditorInterface.open_scene_from_path(s)
	EditorInterface.get_edited_scene_root().faction += 1
	EditorInterface.save_scene()
	EditorInterface.close_scene()

func scan_directory(p: String) -> void:
	var dir := DirAccess.open(p)
	if not dir:
		print("An error occurred when trying to access the path:\n\t" + p)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			scan_directory(dir.get_current_dir() + "/" + file_name)
		else:
			_handle_file(dir.get_current_dir() + "/" + file_name)
		file_name = dir.get_next()

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	scan_directory("res://Combat/Units/Derived units/")
	#var file := FileAccess.open("res://Combat/Units/Derived units/Empire/e01 Squire.tscn", FileAccess.READ)
	#var unit: Unit = load("res://Combat/Units/Derived units/Empire/e01 Squire.tscn")
	#EditorInterface.open_scene_from_path("res://Combat/Units/Derived units/Empire/e01 Squire.tscn")
	#EditorInterface.edit_node()
