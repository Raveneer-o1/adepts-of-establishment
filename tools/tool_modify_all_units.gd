@tool
extends EditorScript

func change_unit(u: Unit) -> void:
	# This function is a template for modifying Unit resources
	# Implement custom unit modification logic here
	u.portrait_texture_path = u.portrait_texture.resource_path

func handle_file(s: String) -> void:
	EditorInterface.open_scene_from_path(s)
	
	var root := EditorInterface.get_edited_scene_root()
	
	if root is Unit:
		change_unit(root)
	else:
		EditorInterface.close_scene()
		return
	
	EditorInterface.save_scene()
	EditorInterface.close_scene()

# Recursively scans a directory and processes all files
func scan_directory(p: String) -> void:
	var dir := DirAccess.open(p)
	
	if not dir:
		print("An error occurred when trying to access the path:\n\t" + p)
		return
	
	# Start reading directory contents
	dir.list_dir_begin()
	
	# Get the first file/folder in the directory
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			# If it's a directory, recursively scan it too
			# This ensures we process files in subfolders as well
			scan_directory(dir.get_current_dir() + "/" + file_name)
		else:
			# If it's a file, process it
			# Note: This will process ALL files, not just scenes
			# You might want to add a file extension check here
			handle_file(dir.get_current_dir() + "/" + file_name)
		
		# Move to the next file/folder in the directory
		file_name = dir.get_next()

# This is the main function that runs when you execute the script
# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	# Start scanning from this directory path
	# The script will recursively process all files in this folder and its subfolders
	scan_directory("res://Combat/Units/Derived units/")
	#handle_file("res://Combat/Units/Derived units/Elemental.tscn")
	
	# Note for beginners: 
	# - This script will open, modify, and save EVERY file in the target directory
	# - Version control system (git in this case) provides backup
	# - The script runs in the editor, so you'll see scenes opening/closing automatically
