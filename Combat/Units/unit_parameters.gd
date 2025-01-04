class_name UnitParameters extends Node

## This class represents inner logic of a unit: its health, damage and abilities
## 
## Specific values are determined in derived classes

@export var unit_name: String

@export var large_unit: bool = false

@export var attack_effect: Resource
@export var other_effects: Array[Resource]

@export_group("Base parameters")
## Base parameters that determine "native" to this type of units values
@export var max_hp := 100
## Base parameters that determine "native" to this type of units values
@export var base_damage := 25
## Base parameters that determine "native" to this type of units values
@export var initiative := 50

@export_group("Override parameters")
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var max_hp_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var base_damage_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var initiative_override: int = -1

var attacks: Array[UnitAttack] = []
# TODO: replace int with Array[int] for multiple actions per round
#var targets_need: int

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

#func get_last_validation(n: int) -> Callable:
	#var size := attacks.size()
	#if size < n and attacks[n].target_validation_override:
		#return attacks[n].target_validation
	#if attacks[size - 1].target_validation_override:
		#return attacks[size - 1].target_validation
	#return check_target_validity

func initialize_variables() -> void:
	parent_unit = get_parent()
	
	if max_hp_override > 0:
		max_hp = max_hp_override
	if base_damage_override >= 0:
		base_damage = base_damage_override
	if initiative_override >= 0:
		initiative = initiative_override
	
	visual_bar.max_value = max_hp
	hp = max_hp
	_set_attacks()

func die() -> void:
	dead = true
	parent_unit.die()

func _set_attacks() -> void:
	pass

#var check_target_validity: Callable = Callable(self, "standart_melee_validity")


func standart_healer_validity(unit: Unit) -> bool:
	if unit.parameters.dead:
		return false
	
	# only attack if units are in the same party
	if parent_unit.party.units.has(unit):
		return true
	return false


func standart_archer_validity(unit: Unit) -> bool:
	if unit.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if parent_unit.party.units.has(unit):
		return false
	return true


func standart_melee_validity(unit) -> bool:
	if unit.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if parent_unit.party.units.has(unit):
		return false
	
	var pos := parent_unit.party_position
	var targets : Array[Unit]
	# step of 2 indicates adjacent units *see Party class documentation*
	var step: int = 2
	
	# === Checking front line ===
	
	# even position indicates front line
	if pos % 2 == 0:
		# check position in front and adjacent positions
		targets = parent_unit.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(unit):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
	
	# odd position indicates back line
	else:
		if not parent_unit.party.front_line_is_empty():
			return false
		# set new pos to check front line first
		step = -1
	
	
	# assuming we can't get out of bounds on the first check
	var in_bounds: bool = true
	while in_bounds:
		step += 2
		
		targets = parent_unit.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(unit):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
		# if get_units_at_positions() returned 2 nulls, we're completely out of bouns
		if targets.size() == 2:
			in_bounds = false
	
	# === Checking back line ===
	
	# even position indicates front line
	if pos % 2 == 0:
		step = 1
	
	# odd position indicates back line
	else:
		step = 2
		targets = parent_unit.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(unit):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
	
	
	in_bounds = true
	while in_bounds:
		targets = parent_unit.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(unit):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
		# if get_units_at_positions() returned 2 nulls, we're completely out of bouns
		if targets.size() == 2:
			in_bounds = false
		
		step += 2
	
	return false

@onready var visual_bar := get_node("VisualBar") as ProgressBar

func take_damage(dmg: int) -> void:
	hp -= dmg
