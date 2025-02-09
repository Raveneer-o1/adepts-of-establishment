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

@export var level: int = 1

@export var base_paramaters: BaseParameters


var attacks: Array[UnitAttack] = []

@export var large_unit: bool = false

@export var immunities: Array[EventBus.AttackType] = []

@export var attack_effect: Resource
@export var other_effects: Array[Resource]

@export_group("Override parameters")
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var max_hp_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var base_damage_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var armor_override := -1
## Setting these parameters will override base parameters (use if you want to experiment but don't want to change the intended behaviour)
@export var evasion_override := -1.0


## Recalculates human-readable armor parameter into actual multiplier.
## The idea is that player can increase
## armor stat indefinitely but will see deminishing returns.
## Thus, it's possible to let players increase the stat as
## much as they want rather than cap it at a specific value.[br]
## NOTE: armor is still capped at [member UnitParameters.ARMOR_CAP] but that value is much harder to achieve
var armor_multiplier: float:
	get:
		if armor >= ARMOR_CAP:
			return 0.1
		return 100.0 / (armor + 100) if armor > 0 else 100.0 / (armor - 100) + 2.0

#region Underlying values

var underlying_HP: int = 1

@onready var underlying_evasion: float = \
		evasion_override if evasion_override > 0 else \
		base_paramaters.evasion if base_paramaters != null else \
		0.02

@onready var underlying_max_HP: int = \
		max_hp_override if max_hp_override > 0 else \
		base_paramaters.max_HP if base_paramaters != null else \
		100

@onready var underlying_base_damage: int = \
		base_damage_override if base_damage_override > 0 else \
		base_paramaters.base_damage if base_paramaters != null else \
		30

@onready var underlying_armor: int = \
		armor_override if armor_override > 0 else \
		base_paramaters.armor if base_paramaters != null else \
		0


#endregion

#region Data broker

var max_hp: int:
	get:
		const stat_name = &"max_HP"
		var underlying_value := underlying_max_HP
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var base_damage: int:
	get:
		const stat_name = &"base_damage"
		var underlying_value := underlying_base_damage
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var armor: int:
	get:
		const stat_name = &"armor"
		var underlying_value := underlying_armor
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var evasion: float:
	get:
		const stat_name = &"evasion"
		var underlying_value := underlying_evasion
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

var _hp: int:
	get:
		if stats_modifiers.has(&"max_HP"):
			var ratio: float = float(underlying_HP) / float(underlying_max_HP)
			@warning_ignore("narrowing_conversion")
			return max_hp * ratio
		return underlying_HP
	set(value):
		if stats_modifiers.has(&"max_HP"):
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

var hp_percentage: float:
	get:
		return float(hp) / float(max_hp)

var effective_current_hp: int:
	get:
		return round(float(hp) / armor_multiplier)

var effective_max_hp: int:
	get:
		return round(float(max_hp) / armor_multiplier)



var dead: bool = false

var parent_unit: Unit

## Contains all modifiers applied to a unit.
## Elements should be pairs <stat_name: StringName, stack:ModifierStack>
var stats_modifiers: Dictionary = {}

@onready var visual_bar := get_node("VisualBar") as TextureProgressBar

func count_effects(effect_name: StringName, except: AppliedEffect = null) -> int:
	var result: int = 0
	for child in get_children():
		if not child is AppliedEffect:
			continue
		if child == except:
			continue
		
		if (child as AppliedEffect).effect_name == effect_name:
			result += 1
	return result

func have_effect(effect_name: StringName, except: AppliedEffect = null) -> bool:
	for child in get_children():
		if not child is AppliedEffect:
			continue
		if child == except:
			continue
		
		if (child as AppliedEffect).effect_name == effect_name:
			return true
	return false

func clean_modifiers() -> void:
	@warning_ignore("untyped_declaration")
	for modifier in stats_modifiers.values():
		(modifier as ModifierStack).clean()

## Adds new modifier to the stack with name [param stat].[br]
## First addition of a stat creates new stack for it.[br]
## [param influence] should have signature [code]func(int) -> int[/code]
## and given previous value of the paramater, it should return a new one[br]
## Avaliable modifiers:[br]
## [code]"max_HP"[/code][br]
## [code]"armor"[/code][br]
## [code]"base_damage"[/code][br]
## [code]"evasion"[/code][br]
## [br][br]It's possible to add any other name but using it would have to be specified explicitly
func add_modifier(stat: StringName, effect: AppliedEffect, influence: Callable) -> void:
	if not stats_modifiers.has(stat):
		stats_modifiers[stat] = ModifierStack.new()
	
	(stats_modifiers[stat] as ModifierStack).add_modifier(effect, influence)


func get_actual_damage(attack: UnitAttack) -> int:
	@warning_ignore("narrowing_conversion")
	return attack.damage_multiplier if attack.damage_override else \
			attack.damage_multiplier * base_damage


## Returns full damage potential of a unit on a per turn basis accounting for accuracy.
## Does not account for multi-targeted attacks
func get_full_damage() -> int:
	var result: float = 0.0
	for attack in attacks:
		result += get_actual_damage(attack) * attack.accuracy * attack.targets_needed
	return round(result)

var initializtion_successful: bool = false

func initialize_variables() -> bool:
	parent_unit = get_parent()
	set_references()
	check_parameters()
	_override_parameters()
	
	if max_hp_override > 0:
		max_hp = max_hp_override
	if base_damage_override >= 0:
		base_damage = base_damage_override
	if armor_override >= 0:
		armor = armor_override
	
	hp = max_hp
	update_visuals()
	
	return initializtion_successful

func update_effects() -> void:
	for stack_name: String in stats_modifiers:
		stats_modifiers[stack_name].clean()
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
	
	#for child in get_children():
		#if child is AppliedEffect:
			#child.queue_free()

func set_references() -> void:
	for child in get_children():
		if child is UnitAttack:
			attacks.append(child)
	
	for attack in attacks:
		attack.initialize(parent_unit)

func check_parameters() -> void:
	# TODO: write check_parameters() function
	initializtion_successful = true

## Applies the effect specified by [param effect_name] by loading and instantiating its scene.
## The effect scene is expected to be located directly in the
## [i]"res://Combat/Effects/AppliedEffects/Scenes/"[/i]
## directory (subdirectories are not searched). The scene file name should match
## [param effect_name] exactly.[br]
## [param params]: Data passed to the effect's initialization method.
## Type and format depend on the specific effect.[br]
## [param force_stackability] defines if [member AppliedEffect.stackable] should
## be overridden with [param override_stackability]
## Returns: The instantiated [AppliedEffect] node, or [code]null[/code] if the effect was immediately 
##  removed (e.g., some one-time effects like cure effects might self-destruct after application).[br]
##  Returns [code]null[/code] and prints a debug warning if the effect scene isn't found.
func apply_effect(
		effect_name: String, 
		params: Variant, 
		force_stackability: bool = false, 
		override_stackability: bool = false
	) -> AppliedEffect:
	
	var effect_path := "res://Combat/Effects/AppliedEffects/Scenes/%s.tscn" % effect_name
	var res: Resource = load(effect_path)
	
	if not res:
		# Log debug warning if resource is missing
		print_debug("Effect '%s' not found at path: %s" % [effect_name, effect_path])
		return null
	
	# Instantiate the effect scene and add to the scene tree
	var child: AppliedEffect = res.instantiate()
	add_child(child)
	
	if force_stackability:
		child.stackable = override_stackability
	
	# Initialize effect with parameters (implementation-specific logic)
	child.initialize(params)
	
	# Handle cases where the effect might self-remove immediately after initialization
	# (e.g., one-time effects that complete their action in initialize())
	if not is_instance_valid(child):
		child = null  # Ensure reference is null if instance became invalid
	
	return child

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
