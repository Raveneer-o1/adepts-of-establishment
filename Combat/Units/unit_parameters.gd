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

var attacks: Array[UnitAttack] = []
# TODO: replace int with Array[int] for multiple actions per round
var targets_need: int

var _hp: int
var hp: int:
	get:
		return _hp
	set(value):
		_hp = value
		visual_bar.value = value
		if _hp <= 0:
			die()

var dead: bool = false

var parent_unit: Unit

func get_last_validation(n: int) -> Callable:
	var size := attacks.size()
	if size < n and attacks[n].target_validation_override:
		return attacks[n].target_validation
	if attacks[size - 1].target_validation_override:
		return attacks[size - 1].target_validation
	return check_target_validity

func initialize_variables() -> void:
	parent_unit = get_parent()
	
	if database_parameters == null:
		print_debug("Resourse not attached!")
		return
	if max_hp <= 0:
		max_hp = database_parameters.max_hp
	if base_damage < 0:
		base_damage = database_parameters.base_damage
	if initiative < 0:
		initiative = database_parameters.initiative
	
	visual_bar.max_value = max_hp
	hp = max_hp
	set_attacks()

func _ready() -> void:
	initialize_variables()

func die() -> void:
	dead = true

func set_attacks() -> void:
	attacks = database_parameters.get_attacks()
	var array: Array[int] = database_parameters.need_targets
	if array.size() > 0:
		targets_need = array[0]
	else:
		targets_need = 1

var check_target_validity: Callable = Callable(self, "standart_melee_validity")

func standart_melee_validity(unit) -> bool:
	return true

@onready var visual_bar := get_node("VisualBar") as ProgressBar

func take_damage(dmg: int) -> void:
	hp -= dmg
