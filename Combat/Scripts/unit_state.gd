extends Node
class_name UnitState

@warning_ignore_start("untyped_declaration")
var level
var large_unit
var immunities
var description
var brief_description
var faction
var unit_type
var unit_class
var needed_xp
var base_damage
var max_hp
var hp
var armor
var evasion
var shielding_chance
var portrait_texture_path
@warning_ignore_restore("untyped_declaration")

var animation_handle: UnitAnimationsHandle:
	get: return animation_handle
	set(value):
		if is_instance_valid(animation_handle):
			animation_handle.queue_free()
		animation_handle = value
		if value: 
			add_child(value)
var sound_player: SoundPlayer:
	get: return sound_player
	set(value):
		if is_instance_valid(sound_player):
			sound_player.queue_free()
		sound_player = value
		if value: 
			add_child(value)

var unit_attacks: Array[Dictionary] = []
var effects: Array[Dictionary] = []

func _init(unit: Unit) -> void:
	if not unit:
		push_error("Null unit")
		return
	read_unit(unit)

## Captures the current parameters of the given [param u]
## and stores them in this [UnitState] object.
func read_unit(u: Unit) -> void:
	var unit_parameters := u.parameters
	#var base_paramaters := unit_parameters.base_paramaters
	
	level = unit_parameters.level
	large_unit = unit_parameters.large_unit
	immunities = unit_parameters.underlying_immunities
	description = u.full_description
	brief_description = u.brief_description
	faction = u.faction
	unit_type = u.unit_type
	unit_class = u.unit_class
	needed_xp = u.needed_xp
	base_damage = unit_parameters.underlying_base_damage
	max_hp = unit_parameters.underlying_max_HP
	hp = unit_parameters.underlying_HP
	armor = unit_parameters.underlying_armor
	evasion = unit_parameters.underlying_evasion
	shielding_chance = unit_parameters.underlying_shielding_chance
	portrait_texture_path = u.portrait_texture_path
	
	animation_handle = u.animation_handle.duplicate()
	sound_player = u.sound_player.duplicate()
	
	_read_attacks(u)
	_read_effects(u)

func _read_effects(u: Unit) -> void:
	#var _effects := []
	for c in u.parameters.get_children():
		if c is AppliedEffect:
			effects.append(construct_effect_dict(c))

func _read_attacks(u: Unit) -> void:
	unit_attacks.clear()
	for c in u.parameters.get_children():
		if c is UnitAttack:
			unit_attacks.append( UnitAttack.serialized(c) )

## Applies the parameters stored in this [UnitState] to the given [param u].
## The [param flags] determine which parameters are updated.
## By default, all parameters are changed:
## [codeblock]
## [
##     &"level",
##     &"large_unit",
##     &"immunities",
##     &"description",
##     &"brief_description",
##     &"faction",
##     &"unit_type",
##     &"unit_class",
##     &"needed_xp",
##     &"attacks",
##     &"effects",
##     &"base_damage",
##     &"max_hp",
##     &"hp",
##     &"armor",
##     &"evasion",
##     &"shielding_chance",
##     &"portrait_texture_path",
##     &"animation_handle",
##     &"sound_player",
## ]
## [/codeblock]
func change_unit_state(
	u: Unit, 
	flags := [
		&"level",
		&"large_unit",
		&"immunities",
		&"description",
		&"brief_description",
		&"faction",
		&"unit_type",
		&"unit_class",
		&"needed_xp",
		&"attacks",
		&"effects",
		&"base_damage",
		&"max_hp",
		&"hp",
		&"armor",
		&"evasion",
		&"shielding_chance",
		&"portrait_texture_path",
		&"animation_handle",
		&"sound_player",
	]
) -> void:
	var unit_parameters := u.parameters
	#var base_paramaters := unit_parameters.base_paramaters
	
	# Technically this gives O(n^2) but the list shouldn't be
	# too large so that's ok
	
	if flags.has(&"level"):
		unit_parameters.level = level
	if flags.has(&"large_unit"):
		unit_parameters.large_unit = large_unit
	if flags.has(&"immunities"):
		unit_parameters.underlying_immunities = immunities
	if flags.has(&"description"):
		u.full_description = description
	if flags.has(&"brief_description"):
		u.brief_description = brief_description
	if flags.has(&"faction"):
		u.faction = faction
	if flags.has(&"unit_type"):
		u.unit_type = unit_type
	if flags.has(&"unit_class"):
		u.unit_class = unit_class
	if flags.has(&"needed_xp"):
		u.needed_xp = needed_xp
	if flags.has(&"effects"):
		_set_effects(u)
	if flags.has(&"base_damage"):
		u.parameters.underlying_base_damage = base_damage
	if flags.has(&"max_hp"):
		u.parameters.underlying_max_HP = max_hp
	if flags.has(&"hp"):
		u.parameters.underlying_HP = hp
	if flags.has(&"armor"):
		u.parameters.underlying_armor = armor
	if flags.has(&"evasion"):
		u.parameters.underlying_evasion = evasion
	if flags.has(&"shielding_chance"):
		u.parameters.underlying_shielding_chance = shielding_chance
	if flags.has(&"portrait_texture_path"):
		u.portrait_texture_path = portrait_texture_path
	if flags.has(&"animation_handle"):
		if u.animation_handle: u.animation_handle.queue_free()
		u.animation_handle = animation_handle.duplicate()
		u.add_child(u.animation_handle)
	if flags.has(&"sound_player"):
		if u.sound_player: u.sound_player.queue_free()
		u.sound_player = sound_player.duplicate()
		u.add_child(u.sound_player)
	
	if flags.has(&"attacks"):
		_set_attacks(u)

func _set_effects(u: Unit) -> void:
	for c in u.parameters.get_children():
		if c is AppliedEffect:
			# FIXME: decouple the UnitState with the effect name
			if c.effect_name == "Polymorph": continue
			c.queue_free()
	for data in effects:
		u.parameters.apply_effect_path(
			data[&"effect_path"],
			data[&"args"],
			false,  # force_stackability
			false,  # override_stackability
			true,   # silent
		)

func _set_attacks(u: Unit) -> void:
	for c in u.parameters.get_children():
		if c is UnitAttack: c.queue_free()
	for data in unit_attacks:
		var attack := UnitAttack.new()
		u.parameters.add_child(attack)
		attack.initialize(u, UnitAttackData.from_dict(data))
	u.arrange_attacks_and_set_next()

func construct_effect_dict(a: AppliedEffect) -> Dictionary:
	var data := a.get_full_data()
	return data
