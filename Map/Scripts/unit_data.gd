class_name UnitData
extends Node

## Contains all data defining a unit outside of combat context.
##
## This class stores complete unit definition and parameter data.[br][br]
##
## Any provided [b]Parameters[/b] values override the unit's corresponding
## default parameters.[br][br]
##
## Design behavior: When a unit spawns into the world, it receives default
## parameters that are independent of the database, allowing units to develop
## stats that differ from their baseline values. For example, a unit can level
## up without evolving, gaining increased stats including level progression.

@export_file_path("*.tscn") var scene_path: String
const database_path := preload("res://Databases/unit_database.gd")

## Position of the unit within the party (see [Party] class documentation). [br]
## Units with position [code]-1[/code] are considered [i]in garrison[/i]
## and do not participate in combat.
@export_range(-1, 6) var party_position: int = -1

@export_category("Parameters")
@export var unit_name: String
@export var attack_data: Array[UnitAttackData]

@export_group("Base parameters")
@export var base_damage: int
@export var max_hp: int
@export var current_hp: int
@export var immunities: Array[GlobalDefs.AttackType]


var database_dict: Dictionary:
	get: return database_path.database.get(unit_name, {})

var description: String:
	get: return database_dict.get("description", "")

var faction: GlobalDefs.Faction:
	get: return database_dict.get("faction", "")

var unit_type: GlobalDefs.UnitType:
	get: return database_dict.get("unit_type", "")

#func  _ready() -> void:
	#database_path.database
