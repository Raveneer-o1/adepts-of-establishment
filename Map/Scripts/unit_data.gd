class_name UnitData
extends Node

## Contains all data defining a unit outside of combat context.
##
## This class stores complete unit definition and parameter data.[br][br]
##
## Any values present in this object override the unit's corresponding
## default parameters during initialization.[br][br]
##
## Design behavior: When a unit spawns into the world, it receives default
## parameters that are independent of the database, allowing units to develop
## stats that differ from their baseline values. For example, a unit can level
## up without evolving, gaining increased stats including level progression. [br][br]
##
## Serialized dictionary looks like this:
## [codeblock]
## {
##     &"scene_path": String,
##     &"level": int,
##     &"large_unit": bool,
##     &"immunities": Array[GlobalDefs.AttackType],
##     &"description": String,
##     &"faction": GlobalDefs.Faction,
##     &"unit_type": GlobalDefs.UnitType,
##     &"needed_xp": int,
##     &"attacks": Array[Dictionary],
##     &"effects": Array[Dictionary],
##     &"base_damage": int,
##     &"max_hp": int,
##     &"armor": int,
##     &"evasion": float,
##     &"shielding_chance": float,
##     &"custom_levelup_path": String,
## }
## [/codeblock]
##
## [b]Currently not implemented:[/b][br]
## This class is not designed for manual instantiation via the editor.
## Units are automatically created with all required fields populated
## during unit spawning events [i](e.g., hiring or evolution)[/i].
##

enum UnitClass{
	Undefined,  ## Noe special effects
	Warrior,    ## Focus on damage
	Tank,       ## Focus on survivability (health, armor)
	Rogue,      ## Focus on evasion
	Archer,     ## Focus on damage and accuracy 
	Mage,       ## Focus on damage at the cost of health
}

@export_file_path("*.tscn") var scene_path: String

## Position of the unit within the party (see [Party] class documentation). [br]
## Units with position [code]-1[/code] are considered [i]in garrison[/i]
## and do not participate in combat.
@export_range(-1, 6) var party_position: int = -1
## Overrides [member unit_name] for representation
@export var personal_name: String
@export var current_hp: int
@export var current_xp: int

@export_category("Parameters")
@export var unit_name: StringName
@export var level: int
@export var attack_data: Array[UnitAttackData]
@export var large_unit: bool
@export var immunities: Array[GlobalDefs.AttackType]
## [codeblock]
## {
##     &"effect_name": String,
##     &"effect_path": String,
##     &"args": Variant,
## }
## [/codeblock]
@export var effects: Array[Dictionary]
@export var needed_xp: int = 1
@export var unit_class: UnitClass = UnitClass.Undefined

@export_group("Base parameters")
@export var base_damage: int
@export var max_hp: int
@export var armor: int
@export var evasion: float
@export var shielding_chance: float

@export var custom_levelup_path: String

const database = GlobalDefs.database_path.database

var database_dict: Dictionary:
	get: return database.get(unit_name, {})

var description: String:
	get: return database_dict.get(&"description", "")

var database_scene_path: String:
	get: return database_dict.get(&"scene_path", "")

var faction: GlobalDefs.Faction:
	get: return database_dict.get(&"faction", GlobalDefs.Faction.Undefined)

var unit_type: GlobalDefs.UnitType:
	get: return database_dict.get(&"unit_type", GlobalDefs.UnitType.Undefined)

var is_dead: bool:
	get: return current_hp <= 0

## If this is not [code]null[/code], this object is considered a copy of this original one
var original: UnitData = null

var levelup_avaliable: bool:
	get: return current_xp >= needed_xp

## Returns the file path to the unit scene resource.
## This path must be added to either [member EventBus.left_units] or
## [member EventBus.right_units] to instantiate the unit when battle begins.
func get_scene_path() -> String:
	var provided_file_exists := FileAccess.file_exists(scene_path)
	var database_file_exists := FileAccess.file_exists(database_scene_path)
	
	if database_scene_path != scene_path:
		print("======= Unit: " + unit_name + ((" (%s)" % personal_name) if personal_name else ""))
		print("Provided path does not match the database")
		if provided_file_exists:
			print("Using provided scene")
			return scene_path
		elif database_file_exists:
			if scene_path: push_error("Provided path does not exist")
			print("Using database scene")
			return database_scene_path
	
	if provided_file_exists:
		return scene_path
	
	push_error("Neither provided scene nor database scene exists!")
	return ""

func _initialize_effect_data() -> void:
	effects.clear()
	for e: Dictionary in database_dict.get(&"effects", []):
		effects.append(e)

func _initialize_attack_data() -> void:
	attack_data.clear()
	var attacks_array: Array[Dictionary]
	attacks_array.assign(database_dict.get(&"attacks", []))
	for a in attacks_array:
		var data := UnitAttackData.from_dict(a)
		attack_data.append(data)

## Initializes unit data with database defaults. [br][br]
## [color=red]Warning:[/color] This method discards all custom unit modifications,
## resets experience to 0, and reloads all defined attacks and effects.
## Should only be called when spawning a new unit into the world.
func initialize(personal: String = "") -> void:
	if not database.has(unit_name):
		push_error("unit name '%s' does not exist in the database" % unit_name)
		return
	
	base_damage = database_dict.get(&"base_damage", 0)
	max_hp = database_dict.get(&"max_hp", 1)
	armor = database_dict.get(&"armor", 0)
	evasion = database_dict.get(&"evasion", 0.0)
	shielding_chance = database_dict.get(&"shielding_chance", 0.0)
	
	level = database_dict.get(&"level", 0)
	needed_xp = database_dict.get(&"needed_xp", 1)
	large_unit = database_dict.get(&"large_unit", false)
	immunities.assign(database_dict.get(&"immunities", []))
	
	custom_levelup_path = database_dict.get(&"custom_levelup_path", "")
	
	personal_name = personal
	current_hp = max_hp
	
	scene_path = database_scene_path
	
	_initialize_attack_data()
	_initialize_effect_data()
	
	current_xp = 0

## This method performs no validation - duplicate effects may be added without checks.
func add_effect(effect: AppliedEffect) -> void:
	if not effect: return
	var full_data := effect.get_full_data()
	UnitData.filter_data(full_data)
	(original.effects if original else effects).append(full_data)

func update_values(u: Unit) -> void:
	if not u: return
	current_hp = u.parameters.hp
	for e: AppliedEffect in u.parameters.get_all_effects():
		if e.persistent: add_effect(e)

# WARNING: this is testing implementation, initialization here will be removed
func _ready() -> void:
	initialize()

func grant_xp(points: int) -> void:
	current_xp += points

func level_up() -> void:
	if custom_levelup_path and FileAccess.file_exists(custom_levelup_path):
		var custom_levelup := load(custom_levelup_path)
		if custom_levelup is LevelupFunction:
			custom_levelup.custom_levelup(self)
			return
	LevelupFunction.default_levelup(self)

func evolve(into: StringName) -> void:
	var prev := unit_name
	unit_name = into
	initialize(personal_name)
	EventBus.unit_evolved.emit(self, prev)

## Recursively processes all Arrays and Dictionaries within [param data]: [br]
## - Serializes [UnitAttack] references into Dictionaries [br]
## - Replaces all other [Object] references with [code]null[/code] [br][br]
## [b]Note:[/b] Dictionary entries with [Object] keys are completely removed.
static func filter_data(data: Variant) -> void:
	#print(data)
	if data is Array:
		var i := -1
		for entry: Variant in data:
			i += 1
			if entry is UnitAttack:
				data[i] = UnitAttack.serialized(entry)
				#print("serialized UnitAttack: " + str(entry))
				continue
			if entry is Object:
				data[i] = null
				continue
			filter_data(entry)
	if data is Dictionary:
		var keys_for_removal := []
		for key: Variant in data:
			if key is Object:
				keys_for_removal.append(key)
				continue
			if data[key] is UnitAttack:
				data[key] = UnitAttack.serialized(data[key])
				#print("serialized unit_attack")
				continue
			if data[key] is Object:
				data[key] = null
				continue
			filter_data(data[key])
		for key: Variant in keys_for_removal:
			data.erase(key)
	#print("=======")
	#print(data)
