class_name UnitParameters extends Node

## This class represents inner logic of a unit: its health, damage and abilities
## 
## Specific values are determined in derived classes

@export var large_unit: bool = false

@export var attack_effect: Resource
@export var other_effects: Array[Resource]

@export_group("Base parameters")
## Base parameters that determine "native" to this type of units values
@export var max_hp := 100
## Base parameters that determine "native" to this type of units values
@export var base_damage := 25
## Base parameters that determine "native" to this type of units values
@export var armor := 0

var armor_multiplier: float:
	get:
		return 100.0 / (armor + 100) if armor > 0 else 100.0 / (armor - 100) + 2.0

@export_group("Override parameters")
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var max_hp_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var base_damage_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var armor_override := -1

var attacks: Array[UnitAttack] = []
# TODO: replace int with Array[int] for multiple actions per round
#var targets_need: int

var _hp: int
var hp: int:
	get:
		return _hp
	set(value):
		if value > max_hp:
			_hp = max_hp
		else:
			_hp = value
		visual_bar.value = _hp
		if _hp <= 0:
			die()

var dead: bool = false

var parent_unit: Unit

func initialize_variables() -> void:
	parent_unit = get_parent()
	set_parameters()
	_override_parameters()
	
	if max_hp_override > 0:
		max_hp = max_hp_override
	if base_damage_override >= 0:
		base_damage = base_damage_override
	if armor_override >= 0:
		armor = armor_override
	
	visual_bar.max_value = max_hp
	hp = max_hp

func die() -> void:
	dead = true
	parent_unit.die()

func set_parameters() -> void:
	if not parent_unit.system.unit_parameters_database:
		print_debug("Database not attached!")
		return
	var databse = parent_unit.system.unit_parameters_database.DATABASE
	if not databse:
		print_debug("Database not found!")
		return
	if not databse.has(parent_unit.unit_name):
		print_debug("Unit '%s' not found in database!" % parent_unit.unit_name)
		return
	var params: Dictionary = databse[parent_unit.unit_name]
	if params.has("Damage"):
		base_damage = params["Damage"]
	if params.has("HP"):
		max_hp = params["HP"]
	if params.has("Armor"):
		armor = params["Armor"]
	if params.has("Attacks"):
		var database_attacks: Array = params["Attacks"]
		for attack in database_attacks:
			var damagemultiplier := 1.0
			var damageoverride := false
			var type := EventBus.AttackType.Physical
			var accuracy := 0.8
			var targets_needed := 2
			var initiative := 40
			var validation := standart_melee_validity
			if attack.has("DamageMultiplier"):
				damagemultiplier = attack["DamageMultiplier"]
			if attack.has("DamageOverride"):
				damageoverride = attack["DamageOverride"]
			if attack.has("Type"):
				type = attack["Type"]
			if attack.has("Accuracy"):
				accuracy = attack["Accuracy"]
			if attack.has("TargetsNeeded"):
				targets_needed = attack["TargetsNeeded"]
			if attack.has("Initiative"):
				initiative = attack["Initiative"]
			if attack.has("Validation"):
				validation = attack["Validation"]
			var new_attack := UnitAttack.new(
				parent_unit,
				damagemultiplier,
				damageoverride,
				validation,
				type,
				accuracy,
				targets_needed,
				initiative
			)
			if attack.has("FindAdditionalTargets"):
				new_attack.find_additional_targets = attack["FindAdditionalTargets"]
				#print(parent_unit.unit_name)
			if attack.has("DamagePolicy"):
				new_attack.damage_policy = attack["DamagePolicy"]
				#print(parent_unit.unit_name)
			
			attacks.append(new_attack)

#var check_target_validity: Callable = Callable(self, "standart_melee_validity")

## Override this function in derived classes to set unique parameters and/or effects
func _override_parameters() -> void:
	pass

func standart_healer_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
	
	# only attack if units are in the same party
	if attacker.party.units.has(target):
		return true
	return false


func standart_archer_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target):
		return false
	return true


func standart_melee_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target):
		return false
	
	var pos := attacker.party_position
	var targets : Array[Unit]
	# step of 2 indicates adjacent units *see Party class documentation*
	var step: int = 2
	
	# === Checking front line ===
	
	# even position indicates front line
	if pos % 2 == 0:
		# check position in front and adjacent positions
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
	
	# odd position indicates back line
	else:
		if not attacker.party.front_line_is_empty():
			return false
		# set new pos to check front line first
		step = -1
	
	
	# assuming we can't get out of bounds on the first check
	var in_bounds: bool = true
	while in_bounds:
		step += 2
		
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(target):
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
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
	
	
	in_bounds = true
	while in_bounds:
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(target):
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

func heal(value: int) -> void:
	hp += value
