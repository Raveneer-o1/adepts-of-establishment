@tool
extends EditorScript

func construct_attack_dict(a: UnitAttack) -> Dictionary:
	print("constructing attack")
	var alternative_actions: Array[Dictionary] = []
	for child: UnitAttack in a.get_children():
		alternative_actions.append(construct_attack_dict(child))
	var res := {
		"damage_multiplier" = a.damage_multiplier,
		"damage_override" = a.damage_override,
		"is_heal" = a.is_heal,
		"type" = a.type,
		"accuracy" = a.accuracy,
		"targets_needed" = a.targets_needed,
		"initiative" = a.initiative,
		"evadable" = a.evadable,
		"tags" = a.tags,
		"target_validation" = a.target_validation.resource_path,
		"additional_targets" = a.additional_targets.resource_path if a.additional_targets else "",
		"damage_policy" = a.damage_policy.resource_path if a.damage_policy else "",
		"applying_effects" = a.applying_effects,
		"alternative_actions" = alternative_actions,
	}
	return res

func construct_effect_dict(a: AppliedEffect) -> Dictionary:
	print("constructing effect")
	var dummy: AppliedEffect = a.get_script().new()
	var data := dummy.get_full_data(a)  # what the actual f
	
	# This is pretty much exclusive to retaliation effect
	if data["args"] is Array:
		for entry: Variant in data["args"]:
			if entry is UnitAttack:
				entry = construct_attack_dict(entry)
	
	dummy.free()
	return data

func read_unit(u: Unit, full_path: String) -> void:
	if dict.has(u.unit_name):
		push_error("Repeating unit name: %s\n\tfile: %s" % [u.unit_name, full_path])
		return
	var attacks := []
	var effects := []
	var unit_parameters: UnitParameters = u.find_child("UnitParameters")
	for c in unit_parameters.get_children():
		if c is UnitAttack:
			attacks.append(construct_attack_dict(c))
		elif c is AppliedEffect:
			effects.append(construct_effect_dict(c))
	
	
	var base_paramaters := unit_parameters.base_paramaters
	#print(base_paramaters.get_indexed("evasion"))
	#return
	var params := {
		"scene_path" = full_path,
		"level" = unit_parameters.level,
		"large_unit" = unit_parameters.large_unit,
		"immunities" = unit_parameters.underlying_immunities,
		"description" = u.full_description,
		"faction" = u.faction,
		"unit_type" = u.unit_type,
		"needed_xp" = u.needed_xp,
		"attacks" = attacks,
		"effects" = effects,
		"base_damage" = base_paramaters.get_indexed("base_damage"),
		"max_hp" = base_paramaters.get_indexed("max_HP"),
		"armor" = base_paramaters.get_indexed("armor"),
		"evasion" = base_paramaters.get_indexed("evasion"),
		"shielding_chance" = base_paramaters.get_indexed("shielding_chance"),
	}
	
	write_unit(u.unit_name, params)
	dict[u.unit_name] = null

func handle_file(s: String) -> void:
	print("\nhandling file: %s\n--------------" % s)
	EditorInterface.open_scene_from_path(s)
	
	var root := EditorInterface.get_edited_scene_root()
	
	if root is Unit:
		read_unit(root, s)
	else:
		EditorInterface.close_scene()
		return
	
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
			handle_file(dir.get_current_dir() + "/" + file_name)
		
		file_name = dir.get_next()
		#break

func write_unit(name: String, params: Dictionary) -> void:
	print("writing " + name)
	var content := ("&\"%s\" : " % name) + str(params) + ","
	content = content.replace("<null>", "null")
	content = content.replace("}", "\n}")
	content = content.replace("{", "{\n")
	content = content.replace("]", "]\n")
	file.store_string(content)
	

var dict: Dictionary
var file : FileAccess
# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	file = FileAccess.open("res://Databases/unit_database.gd", FileAccess.WRITE)
	if not file:
		print("File not opened")
		return
	file.store_line("const database = {")
	scan_directory("res://Combat/Units/Derived units/")
	#handle_file("res://Combat/Units/Derived units/Empire/e15 Elementalist.tscn")
	
	print("Storing end line")
	file.store_line("\n# end of database\n}")
	
	print("Closing file")
	file.close()
	print("Done")
