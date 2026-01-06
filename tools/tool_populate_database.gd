@tool
extends EditorScript

func construct_effect_dict(a: AppliedEffect) -> Dictionary:
	print("\nConstructing effect '%s'" % a.effect_name)
	var dummy: AppliedEffect = a.get_script().new()
	var data := dummy.get_full_data(a)  # what the actual f
	
	UnitData.filter_data(data["args"])
	
	dummy.free()
	print("'%s' is constructed\n" % a.effect_name)
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
			attacks.append(UnitAttack.serialized(c))
		elif c is AppliedEffect:
			effects.append(construct_effect_dict(c))
	
	
	var base_paramaters := unit_parameters.base_paramaters
	var params: Dictionary[StringName, Variant] = {
		"scene_path" = full_path,
		"level" = unit_parameters.level if unit_parameters.level else 1,
		"large_unit" = true if unit_parameters.large_unit else false,
		"immunities" = unit_parameters.underlying_immunities if unit_parameters.underlying_immunities else [],
		"description" = u.full_description if u.full_description else "",
		"brief_description" = u.brief_description if u.brief_description else "",
		"faction" = u.faction if u.faction else GlobalDefs.Faction.Undefined,
		"unit_type" = u.unit_type if u.unit_type else GlobalDefs.UnitType.Undefined,
		"unit_class" = u.unit_class if u.unit_type else UnitData.UnitClass.Undefined,
		"needed_xp" = u.needed_xp if u.needed_xp else 0,
		"attacks" = attacks,
		"effects" = effects,
		"base_damage" = base_paramaters.get_indexed("base_damage"),
		"max_hp" = base_paramaters.get_indexed("max_HP"),
		"armor" = base_paramaters.get_indexed("armor"),
		"evasion" = base_paramaters.get_indexed("evasion"),
		"shielding_chance" = base_paramaters.get_indexed("shielding_chance"),
		"portrait_texture_path" = u.portrait_texture_path if u.portrait_texture_path else "",
		"custom_levelup_path" = unit_parameters.custom_levelup_function.resource_path \
			if unit_parameters.custom_levelup_function else "",
		"cost" = {
			&"gold": u.cost_gold,
			&"stone": u.cost_stone,
			&"mana": u.cost_mana,
		}
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
	#handle_file("res://Combat/Units/Derived units/Empire/e21 Arcanist.tscn")
	
	print("Storing end line")
	file.store_line("\n# end of database\n}")
	
	print("Closing file")
	file.close()
	print("Done")
