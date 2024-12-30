class_name UnitParameters extends Node

## Resource that will be used to determine base parameters
@export var database_parameters: Resource

@export_group("Override parameters")
## Setting these parameters will override parameters from database completely
@export var max_hp: int = -1
## Setting these parameters will override parameters from database completely
@export var base_damage: int = -1
## Setting these parameters will override parameters from database completely
@export var initiative: int = -1

var _hp: int
var hp: int:
	get:
		return _hp
	set(value):
		_hp = value
		if _hp <= 0:
			die()

var dead: bool = false

var unit: Unit

func initialize_variables() -> void:
	unit = get_parent()
	if database_parameters == null:
		print_debug("Resourse not attached!")
		return
	if max_hp <= 0:
		max_hp = database_parameters.max_hp
	if base_damage < 0:
		base_damage = database_parameters.base_damage
	if initiative < 0:
		initiative = database_parameters.initiative
	_hp = max_hp

func _ready() -> void:
	initialize_variables()

func die() -> void:
	dead = true
