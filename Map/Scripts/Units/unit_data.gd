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
##     &"unit_class": UnitData.UnitClass,
##     &"needed_xp": int,
##     &"attacks": Array[Dictionary],  # see UnitAttackData.from_dict()
##     &"effects": Array[Dictionary],
##     &"base_damage": int,
##     &"max_hp": int,
##     &"armor": int,
##     &"evasion": float,
##     &"shielding_chance": float,
##     &"portrait_texture_path": String,
##     &"custom_levelup_path": String,  # has no effect for heroes
##     &"hero_abilities": String,  # if present, this unit is a hero
##     &"map_effects": Dictionary[String, Variant],  # pairs path to script - argument
##     &"cost": Dictionary,  # see below
## }
## 
## # Cost dictionary has the following structure:
## {
##     &"gold": int,
##     &"stone": int,
##     &"mana": int,
## }
## [/codeblock]
##
## [b]Currently not implemented:[/b][br]
## This class is not designed for manual instantiation via the editor.
## Units are automatically created with all required fields populated
## during unit spawning events [i](e.g., hiring or evolution)[/i].
##

#region Static

## Creates and initializes a new [UnitData] instance for the specified unit name.
## Units are identified by name only - ensure [param u_name] matches database exactly.
## If the database marks the unit as a hero (non-empty [code]hero_abilities[/code]
## entry), returns a [HeroData] instance.
static func get_new(u_name: StringName, personal: String = "") -> UnitData:
	var d: Dictionary = GlobalDefs.units_database.database.get(u_name)
	if not d: return null
	var abilities: String = d.get(&"hero_abilities", "")
	var res := HeroData.new() if abilities else UnitData.new()
	res.unit_name = u_name
	res.initialize(personal)
	return res

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

#endregion

enum UnitClass{
	Undefined,  ## No special effects
	Warrior,    ## Focus on damage
	Tank,       ## Focus on survivability (health, armor)
	Rogue,      ## Focus on evasion
	Archer,     ## Focus on damage and accuracy 
	Mage,       ## Focus on damage at the cost of health
}

@export_file_path("*.tscn") var scene_path: String

@export var custom_levelup: LevelupFunction = null
@export var hero_levelup: HeroAbilitiesTree = null

## Position of the unit within the party (see [Party] class documentation). [br]
## Units with position [code]-1[/code] are considered [i]in garrison[/i]
## and do not participate in combat.
@export_range(-1, Party.MAX_UNITS_NUMBER - 1) var party_position: int = -1
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

var cost: ResourceCost

## Retrieved directly from the database on each access. Cannot be modified.
var database_dict: Dictionary:
	get: return GlobalDefs.units_database.database.get(unit_name, {})

## Retrieved directly from the database on each access. Cannot be modified.
var description: String:
	get: return database_dict.get(&"description", "")

## Retrieved directly from the database on each access. Cannot be modified.
var brief_description: String:
	get: return database_dict.get(&"brief_description", "")

## Retrieved directly from the database on each access. Cannot be modified.
var database_scene_path: String:
	get: return database_dict.get(&"scene_path", "")

## Retrieved directly from the database on each access. Cannot be modified.
var faction: GlobalDefs.Faction:
	get: return database_dict.get(&"faction", GlobalDefs.Faction.Undefined)

## Retrieved directly from the database on each access. Cannot be modified.
var unit_type: GlobalDefs.UnitType:
	get: return database_dict.get(&"unit_type", GlobalDefs.UnitType.Undefined)

## Retrieved directly from the database on each access. Cannot be modified.
var portrait_texture_path: String:
	get: return database_dict.get(&"portrait_texture_path", "")

## Retrieved directly from the database on each access. Cannot be modified.
var map_effects_database: Dictionary:
	get: return database_dict.get(&"map_effects", {})

## Equivalent to checking the contition [code]current_hp <= 0[/code]
var is_dead: bool:
	get: return current_hp <= 0

## If this is not [code]null[/code], this object is considered a copy of this original one
var original: UnitData = null

var levelup_available: bool:
	get: return current_xp >= needed_xp

## Returns [MapParty] this unit is a part of or [code]null[/code]
var party: MapParty:
	get:
		var parent := get_parent()
		return parent if parent is MapParty else null

## Returns the faction owning this unit, or [code]null[/code].
## Ownership may be indeterminable if the unit is not a child (direct on indirect)
## of [MapInteractableObject] or if the containing object is not owned.
var unit_owner: MapFaction:
	get:
		var parent := get_parent()
		while parent:
			if parent is MapInteractableObject: return parent.object_owner
			if parent is Map: break
			parent = parent.get_parent()
		return null

## List of all [MapUnitEffect]s applied to this unit
var map_effects: Array[MapUnitEffect]:
	get:
		var res: Array[MapUnitEffect] = []
		for c in get_children():
			if c is MapUnitEffect: res.append(c)
		return res

var _initializer: __UnitData_Initializer__

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

## Initializes unit data with database defaults. [br][br]
## [color=red]Warning:[/color] This method discards all custom unit modifications,
## resets experience to 0, and reloads all defined attacks and effects.
## Should only be called when spawning a new unit into the world.
func initialize(personal: String = "") -> bool:
	assert(not _initializer)
	_initializer = __UnitData_Initializer__.new()
	add_child(_initializer, false, Node.INTERNAL_MODE_BACK)
	
	return _initializer.initialize(personal)

## This method performs no validation - duplicate effects may be added without checks.
func add_effect(effect: AppliedEffect) -> void:
	if not effect: return
	var full_data := effect.get_full_data()
	UnitData.filter_data(full_data)
	(original.effects if original else effects).append(full_data)

## Synchronizes unit data with combat results from the provided [Unit] object.
## Updates values to reflect post-combat state.
## Does not grant experience points.
func update_values(u: Unit) -> void:
	if not u: return
	current_hp = u.parameters.hp
	for e: AppliedEffect in u.parameters.get_all_effects():
		if e.persistent:
			add_effect(e)
			e.persistent = false  # to safeguard against multiple calls

## Does [b]not[/b] trigger levelup automatically.
## Use [member levelup_available] to check.
func grant_xp(points: int) -> void:
	current_xp += points

## Levels the unit up without evolving. For the latter use [method evolve]
func level_up() -> void:
	if hero_levelup and self is HeroData:
		hero_levelup.levelup()
		return
	if custom_levelup:
		custom_levelup.custom_levelup(self)
		return
	LevelupFunction.default_levelup(self)

## Transforms this unit into the one specified in the argument.
## [UnitData] class has no way to check the validity of the provided transformation.
func evolve(into: StringName) -> void:
	var prev := unit_name
	unit_name = into
	var init_success := initialize(personal_name)
	assert (init_success)
	EventBus.unit_evolved.emit(self, prev)

## Attempts to move the unit to the specified [param container].
## Does not validate ownership. [br]
## [b]Important:[/b] The method will proceed even for unexpected containers
## (neither party nor city).
func try_moving_unit(container: Node) -> bool:
	if can_be_moved_to(container):
		_move_unit(container)
		return true
	return false

## Returns if the unit can be moved to the provided [param container].
## Does not validate ownership. [br]
## [b]Important:[/b] The method will return [code]true[/code] even
## for unexpected containers (neither party nor city).
func can_be_moved_to(parent: Node) -> bool:
	if parent == get_parent(): return true
	if self is HeroData: return false
	if not parent: return false
	while parent and parent is not Map:
		if parent is MapParty:
			return parent.can_accept_unit(self)
		if parent is MapCity:
			return true  # Cities can hold unlimited number of units
		parent = parent.get_parent()
	
	print_debug("Unknown destination for moving")
	return true

func _move_unit(container: Node) -> void:
	if not container: return
	var parent := get_parent()
	if parent == container: return
	if parent: reparent(container)
	else: container.add_child(self)
	for e in map_effects:
		e.on_unit_move()

## @deprecated: use [method try_moving_unit] instead.
## Forcibly moves this unit to the provided [param container]
func move_unit(container: Node) -> void:
	push_error("Deprecated call")
	if not container: return
	var parent := get_parent()
	if parent == container: return
	if parent: reparent(container)
	else: container.add_child(self)
	for e in map_effects:
		e.on_unit_move()

func _ready() -> void:
	# WARNING: this is testing implementation, initialization here will be removed
	initialize()
