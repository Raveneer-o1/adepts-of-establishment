class_name __UnitData_Initializer__
extends Node

var this_unit: UnitData

var effects: Array[Dictionary]:
	get: return this_unit.effects

var database_dict: Dictionary:
	get: return this_unit.database_dict
var map_effects_database: Dictionary:
	get: return this_unit.map_effects_database

func _initialize_effect_data() -> void:
	effects.clear()
	for e: Dictionary in database_dict.get(&"effects", []):
		effects.append(e)
	
	MapUnitEffect.apply_serialized(map_effects_database, this_unit)

func _initialize_attack_data() -> void:
	this_unit.attack_data.clear()
	var attacks_array: Array[Dictionary]
	attacks_array.assign(database_dict.get(&"attacks", []))
	for a in attacks_array:
		var data := UnitAttackData.from_dict(a)
		this_unit.attack_data.append(data)

func _set_levelup() -> void:
	var custom_levelup_path: String = database_dict.get(&"custom_levelup_path", "")
	if custom_levelup_path and FileAccess.file_exists(custom_levelup_path):
		var custom_levelup_unchecked := load(custom_levelup_path)
		if custom_levelup_unchecked is LevelupFunction:
			this_unit.custom_levelup = custom_levelup_unchecked
	
	var hero_levelup_path: String = database_dict.get(&"hero_abilities", "")
	if hero_levelup_path and FileAccess.file_exists(hero_levelup_path):
		assert(this_unit is HeroData, "%s is not initialized as hero" % this_unit.unit_name)
		var loaded_resource := load(hero_levelup_path)
		if loaded_resource is PackedScene:
			var hero_levelup_unchecked: Node = loaded_resource.instantiate()
			if not hero_levelup_unchecked: return
			if hero_levelup_unchecked is HeroAbilitiesTree:
				this_unit.hero_levelup = hero_levelup_unchecked
				this_unit.hero_levelup.this_hero = this_unit
			else:
				push_error("'%s' is not a HeroAbilitiesTree" % hero_levelup_path)
				hero_levelup_unchecked.queue_free()

func _initialize_base_params() -> void:
	this_unit.base_damage = database_dict.get(&"base_damage", 0)
	this_unit.max_hp = database_dict.get(&"max_hp", 1)
	this_unit.armor = database_dict.get(&"armor", 0)
	this_unit.evasion = database_dict.get(&"evasion", 0.0)
	this_unit.shielding_chance = database_dict.get(&"shielding_chance", 0.0)
	this_unit.unit_class = database_dict.get(&"unit_class", UnitData.UnitClass.Undefined)
	this_unit.unit_type = database_dict.get(&"unit_type", GlobalDefs.UnitType.Undefined)
	
	this_unit.level = database_dict.get(&"level", 0)
	this_unit.needed_xp = database_dict.get(&"needed_xp", 1)
	this_unit.large_unit = database_dict.get(&"large_unit", false)
	this_unit.immunities.assign(database_dict.get(&"immunities", []))

func initialize(personal: String) -> bool:
	queue_free()
	this_unit = get_parent()
	assert(this_unit)
	if not this_unit.database_dict:
		push_error("unit name '%s' does not exist in the database" % this_unit.unit_name)
		return false
	
	_initialize_base_params()
	
	this_unit.personal_name = personal
	this_unit.current_hp = this_unit.max_hp
	
	this_unit.scene_path = this_unit.database_scene_path
	_set_levelup()
	
	_initialize_attack_data()
	_initialize_effect_data()
	
	this_unit.current_xp = 0
	this_unit.cost = ResourceCost.from_dict(database_dict.get(&"cost", {}))
	
	return true
