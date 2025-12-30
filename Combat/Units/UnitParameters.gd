class_name UnitParameters
extends Node

## This class represents inner logic of a unit: its health, damage and abilities
##
## Fields marked with "[color=yellow][b]Not serialized[/b][/color]", are
## not stored in the database nor in [UnitData] object.
## When a unit instance is initialized, it receives the same value
## as defined in the original scene resource.

## Max damage deviation. Note: actual deviation is maximum between
## [member STANDARD_DAMAGE_DEVIATION] and [member STANDARD_FRACTIONAL_DAMAGE_DEVIATION] * damage
const STANDARD_DAMAGE_DEVIATION = 5
## Fraction of base damage that is used as max deviation. Note: actual deviation is maximum between
## [member STANDARD_DAMAGE_DEVIATION] and [member STANDARD_FRACTIONAL_DAMAGE_DEVIATION] * damage
const STANDARD_FRACTIONAL_DAMAGE_DEVIATION = 0.1

@export var level: int = 1

@export var base_paramaters: BaseParameters

var attacks: Array[UnitAttack]:
	get:
		var res: Array[UnitAttack]
		for child in get_children():
			if child is UnitAttack:
				res.append(child)
		return res

@export var large_unit: bool = false

## Base immunities that are intended to remain unmodified under normal circumstances.
## The intended design is to modify immunities only by adding entries to
## [member stats_modifiers], though this convention is not strictly enforced - 
## the list can be modified dynamically if required.
@export var underlying_immunities: Array[GlobalDefs.AttackType] = []

## [color=yellow][b]Not serialized[/b][/color][br][br]
## This effect is instantiated as the target's child when the unit attacks.
## Intended for visual effects, though this resource undergoes no validation.
## The instantiated object is not tracked as it should free itself after animation
## completion. If using this for objects other than [TemporaryEffect],
## manual memory management is required.
@export var attack_effect: Resource

## [color=yellow][b]Not serialized[/b][/color][br][br]
## Additional effects available for custom implementation.[br]
## @experimental: Not used by default, provided for extended functionality.
@export var other_effects: Array[Resource]

@export_group("Override parameters")
## Setting these parameters will override base parameters (use if you want to experiment
## but don't want to change the intended behavior)
@export var max_hp_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment
## but don't want to change the intended behavior)
@export var base_damage_override: int = -1
## Setting these parameters will override base parameters (use if you want to experiment
## but don't want to change the intended behavior)
@export var armor_override := -1
## Setting these parameters will override base parameters (use if you want to experiment
## but don't want to change the intended behavior)
@export var evasion_override := -1.0
## Setting these parameters will override base parameters (use if you want to experiment
## but don't want to change the intended behavior)
@export var shielding_chance_override := -1.0
## Setting these parameters will override base parameters (use if you want to experiment
## but don't want to change the intended behavior)

## Defines the scaling factor for armor values.
## When armor reaches this value, incoming damage is approximately halved. [br][br]
## For example, setting this to [code]100[/code] means armor values typically range
## up to ~100 with only exceptionally sturdy of buffed units going beyond that.[br][br]
## [color=lightgreen][b]Note:[/b] Changing this value would also mean that armor of
## all units now provides different damage reduction. Keep that in mind if
## you decide to change it: you might have to rebalance unit parameters.[/color]
const ARMOR_SCALE = 100
## Minimum possible damage multiplier from armor.
## Note: Actual multiplier will rarely reach this low as it would require
## extremely high armor values.
const ARMOR_MIN_MULTIPLIER = 0.1

const _ARMOR_SCALE_COMPL = int(ARMOR_SCALE * (1.0 - ARMOR_MIN_MULTIPLIER))
const _ARMOR_NEGATIVE_FACTOR = - float(_ARMOR_SCALE_COMPL) / float(ARMOR_SCALE ** 2)

## Recalculates human-readable armor parameter into actual multiplier.[br][br]
##
## For positive armor values, the multiplier asymptotically approaches
## [constant ARMOR_MIN_MULTIPLIER].[br]
## Adjust [constant ARMOR_SCALE] to modify the function's steepness.[br]
## For negative values linearly increase with no caps or restrictions.
## Slope in this case is calculated so the entire function is smooth
## (i.e, slope becomes more negative with [constant ARMOR_SCALE] decrease)[br]
## [br]
## [i]
## The idea is that players can increase
## armor stat indefinitely but will see diminishing returns.
## Thus, it's possible to let players increase the stat as
## much as they want rather than cap it at a specific value.
## [/i]
var armor_multiplier: float:
	get:
		if armor == 0: return 1.0
		if armor < 0: return armor * _ARMOR_NEGATIVE_FACTOR + 1.0
		return float(_ARMOR_SCALE_COMPL) / float(ARMOR_SCALE + armor) + ARMOR_MIN_MULTIPLIER

#region Underlying values

## Base HP value before applying any modifiers - stores the actual numerical value
var underlying_HP: int = 1

@onready var underlying_evasion: float = \
		evasion_override if evasion_override > 0 else \
		base_paramaters.evasion if base_paramaters != null else \
		0.0

@onready var underlying_max_HP: int = \
		max_hp_override if max_hp_override > 0 else \
		base_paramaters.max_HP if base_paramaters != null else \
		1

@onready var underlying_base_damage: int = \
		base_damage_override if base_damage_override > 0 else \
		base_paramaters.base_damage if base_paramaters != null else \
		1

@onready var underlying_armor: int = \
		armor_override if armor_override > 0 else \
		base_paramaters.armor if base_paramaters != null else \
		0

@onready var underlying_shielding_chance: float = \
		shielding_chance_override if shielding_chance_override > 0.0 else \
		base_paramaters.shielding_chance if base_paramaters != null else \
		0.0

var underlying_shielding: bool = false

#endregion

#region Data broker

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
## [br][br]
## Unlike other data broker fields, this property returns a shallow copy of the
## base value with modifications applied from the associated [ModifierStack].
var immunities: Array[GlobalDefs.AttackType]:
	get:
		const stat_name = &"immunity"
		var underlying_value := underlying_immunities.duplicate()
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
var shielding: bool:
	get:
		const stat_name = &"shielding"
		var underlying_value := underlying_shielding
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value
	set(value):
		underlying_shielding = value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
var shielding_chance: float:
	get:
		const stat_name = &"shielding_chance"
		var underlying_value := underlying_shielding_chance
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
var max_hp: int:
	get:
		const stat_name = &"max_HP"
		var underlying_value := underlying_max_HP
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
var base_damage: int:
	get:
		const stat_name = &"base_damage"
		var underlying_value := underlying_base_damage
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
## [br][br]
## Returns the armor value. For calculations use [member armor_multiplier] instead.
var armor: int:
	get:
		const stat_name = &"armor"
		var underlying_value := underlying_armor
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
var evasion: float:
	get:
		const stat_name = &"evasion"
		var underlying_value := underlying_evasion
		if stats_modifiers.has(stat_name):
			return (stats_modifiers[stat_name] as ModifierStack).get_effective_value(underlying_value)
		return underlying_value

## Returns a human-friendly evasion representation rather than raw probabilities.
## The idea is to never show actual percentages to the player and avoid behind-the-scenes
## number manipulation (as it's usually done to improve player perception). [br]
## Returns [code]0.0[/code] if evasion is 0.0 (can not evade) [br]
## Returns [code]INF[/code] if evasion is 1.0 (guaranteed evasion) [br] [br]
## [center][i]
## Conversion examples: [br]
## 0.05 (5%) → 0.052631 [br]
## 0.1 (10%) → 0.111111 [br]
## 0.2 (20%) → 0.25 [br]
## 0.3 (30%) → 0.428571 [br]
## 0.5 (50%) → 1.0 [br]
## 0.75 (75%) → 3.0
## [/i][/center]
var evasion_represetation: float:
	get:
		var ev := evasion
		if ev >= 1.0: return INF
		return ev / (1.0 - ev)

# Intermediate property that applies modifiers to get effective HP value
# Setting this value maintains the same HP ratio when max_HP modifiers are active
var _hp: int:
	get:
		if stats_modifiers.has(&"max_HP"):
			var ratio: float = float(underlying_HP) / float(underlying_max_HP)
			return roundi(max_hp * ratio)
		return underlying_HP
	set(value):
		if stats_modifiers.has(&"max_HP"):
			var ratio: float = float(value) / float(max_hp)
			underlying_HP = roundi(ratio * underlying_max_HP)
		else:
			underlying_HP = value

## [color=yellow]Data broker:[/color] this property is part of the data broker system.
## Use to access values instead of directly accessing underlying parameters.
## [br][br]
## Public interface for HP - clamps values to maximum and triggers death when reaching zero.
var hp: int:
	get:
		return _hp
	set(value):
		if value > max_hp:
			value = max_hp
		_hp = value
		if value <= 0:
			dead = true
#endregion

var hp_percentage: float:
	get:
		return float(hp) / float(max_hp)

var effective_current_hp: int:
	get:
		return roundi(float(hp) / armor_multiplier / (1.0 - evasion))

var effective_max_hp: int:
	get:
		return roundi(float(max_hp) / armor_multiplier / (1.0 - evasion))

var dead: bool = false

var parent_unit: Unit

## Contains all modifiers applied to a unit.
var stats_modifiers: Dictionary[StringName, ModifierStack] = {}

func get_all_effects() -> Array[AppliedEffect]:
	var result: Array[AppliedEffect] = []
	for child in get_children():
		if child is AppliedEffect:
			result.append(child)
	return result

func count_effects(effect_name: StringName, except: AppliedEffect = null) -> int:
	var result: int = 0
	for child in get_children():
		if child is not AppliedEffect:
			continue
		if child == except:
			continue
		
		if (child as AppliedEffect).effect_name == effect_name:
			result += 1
	return result

func have_effect(effect_name: StringName, except: AppliedEffect = null) -> bool:
	for child in get_children():
		if child is not AppliedEffect:
			continue
		if child == except:
			continue
		
		if (child as AppliedEffect).effect_name == effect_name:
			return true
	return false

## Returns the first instance of the [param effect_name]
## or [code]null[/code] if none is found.
func find_effect(effect_name: StringName, except: AppliedEffect = null) -> AppliedEffect:
	for child in get_children():
		if child is not AppliedEffect:
			continue
		if child == except:
			continue
		
		if (child as AppliedEffect).effect_name == effect_name:
			return child
	return null

## Removes inactive modifiers from all [ModifierStack]s.
## A modifier is considered inactive if its associated [AppliedEffect] reference
## is invalid (e.g., the effect was freed) or if the effect is currently silenced.
func clean_modifiers() -> void:
	for modifier: ModifierStack in stats_modifiers.values():
		modifier.clean()

## Adds a new modifier to the stack for the specified [param stat].[br]
## The first addition of a stat creates its stack.[br]
## [param influence] should be a function
## that takes the previous value and returns the modified value.[br][br]
## Predefined modifiers:[br]
## [code]"max_HP"[/code][br]
## [code]"armor"[/code][br]
## [code]"base_damage"[/code][br]
## [code]"evasion"[/code][br]
## [code]"shielding_chance"[/code][br]
## [code]"shielding"[/code][br]
## [code]"immunity"[/code][br]
## [br]Custom stat names can be added but must be explicitly handled.
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
	return roundi(result)

var initializtion_successful: bool = false

func _init_effects(array: Array[Dictionary]) -> void:
	for e in get_all_effects(): e.free()
	for effect_data in array:
		apply_effect_path(effect_data[&"effect_path"], effect_data[&"args"])

func _init_attacks(array: Array[UnitAttackData]) -> void:
	for a in attacks: a.free()
	for attack_data in array:
		var attack := UnitAttack.new()
		add_child(attack)
		attack.initialize(parent_unit, attack_data)

func _read_data(data: UnitData) -> void:
	level = data.level
	large_unit = data.large_unit
	underlying_HP = data.current_hp
	if max_hp_override < 0:
		underlying_max_HP = data.max_hp
	
	underlying_immunities = data.immunities
	if base_damage_override < 0:
		underlying_base_damage = data.base_damage
	if armor_override < 0:
		underlying_armor = data.armor
	if evasion_override < 0:
		underlying_evasion = data.evasion
	if shielding_chance_override < 0:
		underlying_shielding_chance = data.shielding_chance
	
	_init_effects(data.effects)
	_init_attacks(data.attack_data)
	
	hp = hp  # you don't say
	# this is needed because hp updates "dead" flag and triggers death
	# also clamps the value to max_hp in case something went wrong with the data

## Initializes references. Returns if initializtion was successful.
func initialize_variables(data: UnitData) -> bool:
	parent_unit = get_parent()
	if data: _read_data(data)
	else: set_references()
	
	check_parameters()
	
	#hp = max_hp
	parent_unit.update_visuals()
	
	return initializtion_successful

## See [method Unit.update_visuals]
func update_effects() -> void:
	for stack_name: String in stats_modifiers:
		stats_modifiers[stack_name].clean()
	parent_unit.update_visuals()

var initialized: bool = false

## Applies all effects. Safe to call multiple times: has no effect after the first call.
func initialize_effects() -> void:
	if initialized:
		return
	initialized = true
	for child in get_children():
		if child is AppliedEffect:
			child.initialize()
	parent_unit.update_visuals()
	EventBus.turn_started.connect(_turn_start_reaction)

func set_references() -> void:
	for attack in attacks:
		attack.initialize(parent_unit, null)

func check_parameters() -> void:
	# initializtion_successful is false at the start
	if not base_paramaters:  return
	for attack in attacks:
		if not is_instance_valid(attack) or \
		attack.is_queued_for_deletion():
			return
	initializtion_successful = true

## Applies an effect using a scene file path instead of an effect name.
## Functionally identical to [method apply_effect] but uses direct path reference.
func apply_effect_path(
	effect_path: String, 
	params: Variant, 
	force_stackability: bool = false, 
	override_stackability: bool = false
) -> AppliedEffect:
	var res: Resource = load(effect_path)
	if not res:
		push_error("Effect not found: %s" % effect_path)
		return null
	
	var child: AppliedEffect = res.instantiate()
	add_child(child)
	
	if force_stackability:
		child.stackable = override_stackability
	
	# Initialize effect with parameters (implementation-specific logic)
	child.initialize(params)
	
	# Handle cases where the effect might self-remove immediately after initialization
	# (e.g., one-time effects that complete their action in initialize())
	if not is_instance_valid(child) or child.is_queued_for_deletion():
		child = null
	
	if child: EventBus.effect_applied.emit(child)
	return child

## Applies the effect specified by [param effect_name] by loading and instantiating its scene.
## The effect scene is expected to be located directly in the
## [i]"res://Combat/Effects/AppliedEffects/Scenes/"[/i]
## directory (subdirectories are not searched). The scene file name should match
## [param effect_name] exactly.[br]
## [param params]: Data passed to the effect's initialization method.
## Type and format depend on the specific effect.[br]
## [param force_stackability] defines if [member AppliedEffect.stackable] should
## be overridden with [param override_stackability].[br]
## Returns: The instantiated [AppliedEffect] node, or [code]null[/code] if the effect was immediately 
## removed (e.g., some one-time effects like cure effects might self-destruct after application). [br]
## Returns [code]null[/code] and prints a debug warning if the effect scene isn't found.
func apply_effect(
		effect_name: String, 
		params: Variant, 
		force_stackability: bool = false, 
		override_stackability: bool = false
	) -> AppliedEffect:
	
	var effect_path := "res://Combat/Effects/AppliedEffects/Scenes/%s.tscn" % effect_name
	return apply_effect_path(
		effect_path,
		params,
		force_stackability,
		override_stackability,
	)

func _turn_start_reaction(_unit: Unit) -> void:
	update_effects()

## Deals damage bypassing armor. Returns actual damage taken.
func take_direct_damage(dmg: int, randomize_damage: bool = false) -> int:
	if randomize_damage:
		var random_deviation: int = max(
			dmg * STANDARD_FRACTIONAL_DAMAGE_DEVIATION,
			STANDARD_DAMAGE_DEVIATION
		)
		dmg += randi_range(-random_deviation, random_deviation)
	
	var original_hp := hp
	hp -= dmg
	var taken_dmg := original_hp - hp
	
	EventBus.damage_taken.emit(parent_unit, taken_dmg)
	if taken_dmg > 0: parent_unit.sound_player.play_damage_sound(
			(float(taken_dmg) / float(hp)) * parent_unit.sound_player._SOUND_MULTIPLIER
		)
	elif taken_dmg < 0: parent_unit.sound_player.play_heal_sound(
			(absf(taken_dmg) / float(hp)) * parent_unit.sound_player._SOUND_MULTIPLIER
		)
	return taken_dmg

## Returns actual damage taken.
func take_damage(dmg: int, randomize_damage: bool = true) -> int:
	if parent_unit.defense_stance:
		dmg /= 2
		
	@warning_ignore("narrowing_conversion")
	dmg *= armor_multiplier
	if randomize_damage:
		var random_deviation: int = max(
			dmg * STANDARD_FRACTIONAL_DAMAGE_DEVIATION, 
			STANDARD_DAMAGE_DEVIATION
		)
		dmg += randi_range(-random_deviation, random_deviation)
	
	# needs to be this way because hp is a property that does some more calculations
	var original_hp := hp
	hp -= dmg
	var taken_dmg := original_hp - hp
	
	EventBus.damage_taken.emit(parent_unit, taken_dmg)
	if taken_dmg > 0: parent_unit.sound_player.play_damage_sound(
			(float(taken_dmg) / float(hp)) * parent_unit.sound_player._SOUND_MULTIPLIER
		)
	elif taken_dmg < 0: parent_unit.sound_player.play_heal_sound(
			(absf(taken_dmg) / float(hp)) * parent_unit.sound_player._SOUND_MULTIPLIER
		)
	return taken_dmg

## Returns actual health restored.
func heal(value: int) -> int:
	var original_hp: int = hp
	hp += value
	var healed_hp := hp - original_hp
	if healed_hp > 0: parent_unit.sound_player.play_heal_sound(
			( float(healed_hp) / float(hp) ) * parent_unit.sound_player._SOUND_MULTIPLIER
		)
	elif healed_hp < 0: parent_unit.sound_player.play_damage_sound(
			( absf(healed_hp / float(hp)) ) * parent_unit.sound_player._SOUND_MULTIPLIER
		)
	return healed_hp
