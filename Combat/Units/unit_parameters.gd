class_name UnitParameters extends Node

## This class represents inner logic of a unit: its health, damage and abilities

## Armor = 900 is the equivalent of .1 multiplier. In order for the damage to not be cut more than 10 times
## armor is capped at this value
const ARMOR_CAP = 900

## Max damage deviation. Note: actual deviation is maximum between
## [code]STANDART_DAMAGE_DEVIATION[/code] and [code]STANDART_FRACTIONAL_DAMAGE_DEVIATION * damage[/code]
const STANDART_DAMAGE_DEVIATION = 5
## Fraction of base damage that is used as max deviation. Note: actual deviation is maximum between
## [code]STANDART_DAMAGE_DEVIATION[/code] and [code]STANDART_FRACTIONAL_DAMAGE_DEVIATION * damage[/code]
const STANDART_FRACTIONAL_DAMAGE_DEVIATION = 0.1


@export var large_unit: bool = false

@export var attack_effect: Resource
@export var other_effects: Array[Resource]

@export_group("Override parameters")
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var max_hp_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var base_damage_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var armor_override := -1


## Recalculates human-readable armor parameter into actual multiplier.
## The idea is that player can increase
## armor stat indefinitely but will see deminishing returns.
## Thus, it's possible to let players increase the stat as
## much as they want rather than cap it at a specific value.[br]
## NOTE: armor is still capped at [member UnitParameters.ARMOR_CAP] but that value is much harder to acheve
var armor_multiplier: float:
	get:
		if armor >= ARMOR_CAP:
			return 0.1
		return 100.0 / (armor + 100) if armor > 0 else 100.0 / (armor - 100) + 2.0

#region Underlying values

var underlying_HP: int

var underlying_max_HP: int

var underlying_base_damage: int

var underlying_armor: int


#endregion

#region Data broker

var max_hp: int:
	get:
		const stat_name = "max_HP"
		var underlying_value := underlying_max_HP
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var base_damage: int:
	get:
		const stat_name = "base_damage"
		var underlying_value := underlying_base_damage
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var armor: int:
	get:
		const stat_name = "armor"
		var underlying_value := underlying_armor
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var _hp: int:
	get:
		if stats_modifiers.has("max_HP"):
			var ratio: float = float(underlying_HP) / float(underlying_max_HP)
			@warning_ignore("narrowing_conversion")
			return max_hp * ratio
		return underlying_HP
	set(value):
		if stats_modifiers.has("max_HP"):
			var ratio: float = float(value) / float(max_hp)
			underlying_HP = roundi(ratio * underlying_max_HP)
		else:
			underlying_HP = value

var hp: int:
	get:
		return _hp
	set(value):
		if value > max_hp:
			value = max_hp
		_hp = value
		visual_bar.value = _hp
		if value <= 0:
			die()
#endregion

var attacks: Array[UnitAttack] = []

var dead: bool = false

var parent_unit: Unit

var stats_modifiers: Dictionary = {}

@onready var visual_bar := get_node("VisualBar") as ProgressBar


## Adds new modifier to the stack with name [code]stat[/code].[br]
## First addition of a stat creates new stack for it.
func add_modifier(stat: StringName, effect: AppliedEffect, influence: Callable) -> void:
	if not stats_modifiers.has(stat):
		stats_modifiers[stat] = ModifierStack.new()
	
	(stats_modifiers[stat] as ModifierStack).add_modifier(effect, influence)

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
	
	hp = max_hp
	update_visuals()
	#initialize_effects()

func update_effects() -> void:
	for stack in stats_modifiers:
		stats_modifiers[stack].clear()
	update_visuals()

func update_visuals() -> void:
	visual_bar.max_value = max_hp
	visual_bar.value = hp

var initialized: bool = false

func initialize_effects() -> void:
	if initialized:
		return
	initialized = true
	for child in get_children():
		if child is AppliedEffect:
			child.initialize()
	update_visuals()
	EventBus.turn_started.connect(turn_start_reaction)

func die() -> void:
	dead = true
	parent_unit.die()
	
	for child in get_children():
		if child is AppliedEffect:
			child.queue_free()

func set_parameters() -> void:
	if not parent_unit.system.unit_parameters_database:
		print_debug("Database not attached!")
		return
	var database = parent_unit.system.unit_parameters_database.DATABASE
	if not database:
		print_debug("Database not found!")
		return
	if not database.has(parent_unit.unit_name):
		print_debug("Unit '%s' not found in database!" % parent_unit.unit_name)
		return
	
	var params: Dictionary = database[parent_unit.unit_name]
	if params.has("Damage"):
		underlying_base_damage = params["Damage"]
	if params.has("HP"):
		underlying_max_HP = params["HP"]
	if params.has("Armor"):
		underlying_armor = params["Armor"]
	
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
			if attack.has("Effects"):
				#print(parent_unit.unit_name)
				new_attack.applying_effects = (attack["Effects"] as Dictionary)
			
			attacks.append(new_attack)

func apply_effect(effect_name: String, params: Variant):
	var res : Resource = load("res://Combat/Effects/AppliedEffects/Scenes/%s.tscn" % effect_name)
	if not res:
		print_debug(effect_name + " not found as an effect!")
	var child = res.instantiate()
	add_child(child)
	(child as AppliedEffect).initialize(params)

func turn_start_reaction(_unit: Unit) -> void:
	update_effects()

## Override this function in derived classes to set unique parameters and/or effects
func _override_parameters() -> void:
	pass

func take_direct_damage(dmg: int, randomize_damage: bool = false) -> int:
	if randomize_damage:
		var random_deviation: int = max(dmg * STANDART_FRACTIONAL_DAMAGE_DEVIATION, STANDART_DAMAGE_DEVIATION)
		dmg += randi_range(-random_deviation, random_deviation)
	
	var original_hp := hp
	hp -= dmg
	return original_hp - hp


func take_damage(dmg: int, randomize_damage: bool = true) -> int:
	@warning_ignore("narrowing_conversion")
	dmg *= armor_multiplier
	if randomize_damage:
		var random_deviation: int = max(dmg * STANDART_FRACTIONAL_DAMAGE_DEVIATION, STANDART_DAMAGE_DEVIATION)
		dmg += randi_range(-random_deviation, random_deviation)
	
	var original_hp := hp
	hp -= dmg
	return original_hp - hp


func heal(value: int) -> void:
	hp += value


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
