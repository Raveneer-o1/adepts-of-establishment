@tool
extends EditorScript

func construct_attack_dict(a: UnitAttack) -> Dictionary:
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
		"target_validation" = a.target_validation.resource_path if a.target_validation else "",
		"additional_targets" = a.additional_targets.resource_path if a.additional_targets else "",
		"damage_policy" = a.damage_policy.resource_path if a.damage_policy else "",
		"applying_effects" = a.applying_effects,
	}
	return res

func construct_effect_dict(a: AppliedEffect) -> Dictionary:
	return {
		"effect" = a.effect_name,
		# this does not work because we can't address non-static
		# instance method from a tool script
		"args" = a.get_full_data()
	}

func read_unit(u: Unit, full_path: String) -> void:
	if dict.has(u.name):
		push_error("Repeating unit name: " + u.name)
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
		"attacks" = attacks,
		"effects" = effects,
		"base_damage" = base_paramaters.get_indexed("base_damage"),
		"max_hp" = base_paramaters.get_indexed("max_HP"),
		"armor" = base_paramaters.get_indexed("armor"),
		"evasion" = base_paramaters.get_indexed("evasion"),
		"shielding_chance" = base_paramaters.get_indexed("shielding_chance"),
	}
	
	dict[u.name] = params

func handle_file(s: String) -> void:
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

var dict: Dictionary

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	scan_directory("res://Combat/Units/Derived units/")
	#handle_file("res://Combat/Units/Derived units/Elemental.tscn")
	
	var file := FileAccess.open("res://Databases/unit_database.gd", FileAccess.WRITE)
	if not file:
		print("File not opened")
		return
	var content := "const database = " + str(dict)
	content = content.replace("<null>", "null")
	file.store_string(content)
	file.close()
