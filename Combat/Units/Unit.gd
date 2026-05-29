class_name Unit
extends Node2D

## Unit is central combat entity, they perform actions during combat.
##
## [Unit] objects are the main part of the battle.
## [Party] class has an array of [UnitSpot] objects, each [UnitSpot] may or may not
## contain a [Unit] object. [Unit] itself is an object that is intended to handle high-level
## interactions with the rest of the system: receiving targets for attacks and delegating
## incoming attacks to [UnitParameters], making queries to [UnitAnimationsHandle] etc. [br] [br]
##
## Term [i]"attack"[/i] usually refers to a specific action a unit can perform. Each attack is
## performed on a separate turn and each unit can have multiple different attacks.
## Each [Unit] object has a list of attacks (as [UnitAttack] nodes). At the start of each round
## this list is copied (shallow copy) into [member attacks_for_this_round].
## This list is emptied one-by-one by removing attacks into [member current_attack]
## and later into [Attack] constructor. [br] [br]
##
## When the unit attacks, [Attack] object is created.
## [Attack] is a class that represents attack in progress. It copies every relevant field
## from [UnitAttack] but is independent. When the [Attack] object is created,
## [signal EventBus.attack_booked] is emitted and all units trigger their relevant effects (if any).
## These effects can change [Attack] object without changing the original [UnitAttack]
## (that's why there's two classes). [br] [br]
##
## After the signal is emitted and all effects are applied, the attack is resolved by [Unit] object.
## This means populating [member parameter_snapshots] as necessary. This is done to sync animations:
## when the animation reaches active frame, [method finilize_attack]
## is called on a unit and the values are updated. 
## As a safeguard, at the end of the animation [method finalize_all_attacks] is also called. [br] [br]
##
## [Unit] class only handles delegation of the effects to [UnitParameters], it does not store 
## any effects. There are fields and methods like [method clean_effects] but they only handle
## visual representation, not the actual behavior or other logic. [br] [br]
##
## [member unit_type] defines default behavior for different unit classes: [br]
## - Melee units automatically gain [b]shield[/b] when assuming defense stance (see below) [br]
## - Archer units automatically add the [code]&shot[/code] tag to their attacks [br]
## - Mage units have no special behavior by default. Intended as long-range combatants
##   with typically lower damage but without the archer's shield penalty since their
##   attacks lack the [code]&shot[/code] tag [br]
## - Support units can be shielded even by units that are not currently [i]shielding[/i][br]
## [br]
##
## [b]Shielding[/b] is a mechanic that allows units in the front line to protect units in
## the back. When a unit [i]shields[/i], every attack with a tag [code]&shot[/code] 
## targeted at the unit behind has a chance of being redirected to the shielding unit.
## This mechanic by itself does not reduce incoming damage but shielding effects are often 
## coupled with armor increase. [br] [br]
##
## [color=yellow]Note:[/color] This class is not intended to be overriden.
## Extend functionality through component nodes rather than inheritance.[br]
## [b]See also:[/b] [CombatSystem], [UnitAttack], [Attack]

const EFFECT_ICONS_SCALE = 0.75
## Delay in seconds between proccesing skip turn and procceding to the next stage
const SKIP_DELAY = 0.4

#region Export variables

@export var unit_name: String
## Unit type is used to define default behavior if it's not overriden elsewhere.
## Note: any other field or effect should have a priority over this ruleset.
@export var unit_type: GlobalDefs.UnitType = GlobalDefs.UnitType.Undefined
## @experimental: currently does not have any impact
@export var faction: GlobalDefs.Faction
## Experience required to level up. This value has no combat effect,
## only relevant for calculating the results and for the map
@export var needed_xp: int = 1
## Defines the default behavior of a unit (e.g., when leveling up, warriors will
## increase health, tanks - armor, mages - damage, etc.).
## Unlike [member unit_type], this value is not designed to have a direct impact
## on the combat
@export var unit_class: UnitData.UnitClass = UnitData.UnitClass.Undefined
@export_multiline var brief_description: String
@export_multiline var full_description: String
var portrait_texture: Texture2D:
	get: return DataBuffer.get_image(portrait_texture_path)
@export_file_path("*.*") var portrait_texture_path: String
## If present, this unit will be treated as a hero.
@export_file_path("*.tscn") var hero_levelup_tree: String

@export_group("Cost")
## Determines the resources player will need to pay to hire this unit.
@export var cost_gold: int = 0
## Determines the resources player will need to pay to hire this unit.
@export var cost_stone: int = 0
## Determines the resources player will need to pay to hire this unit.
@export var cost_mana: int = 0
#endregion


@onready var animation_handle: UnitAnimationsHandle = get_node("AnimationHandle")
@onready var spot: UnitSpot = get_parent()
@onready var effect_icons_container: HBoxContainer = $EffectIconsContainer
@onready var sound_player: SoundPlayer = $SoundPlayer
@onready var visual_bar := get_node("VisualBar") as TextureProgressBar

#region Variables

# Associated components and metadata
var parameters: UnitParameters
var party: Party
var system: CombatSystem

## Stores unit parameter snapshots taken during attack resolution for animation synchronization.
## Since attacks resolve completely on the first [signal EventBus.attack_reached] emission,
## these snapshots preserve intermediate states needed for sequenced visual effects.
var parameter_snapshots: Array[UnitParametersSnapshot] = []

## This flag is used during the initialization exclusively. 
## It's here to prevent calling error-prone functions before the object is fully initialized.
## This is required because sometimes units are added during the combat.
## And it may cause problems without this check.
var initialized: bool = false

var displayed_icons: Dictionary[TextureRect, AppliedEffect]

## Position in the party. Even numbers represent fron line, odd numbers - back line.
## Position is also index of this unit in the [member Party.unit_spots] and [member Party.units]
var party_position: int:
	get: return spot.party_position

## List of targets player or AI have chosen. This list is passed as an argument to a new [Attack]
## when [method start_attacking] is called.
var chosen_targets: Array[Unit]:
	get:
		var result: Array[Unit] = []
		for chosen_spot in chosen_spots:
			if chosen_spot.unit != null:
				result.append(chosen_spot.unit)
		return result

## List of spots player or AI have chosen.
var chosen_spots: Array[UnitSpot] = []

var _current_attack: UnitAttack
var alternative_action_index: int = 0
var alternative_action_count: int:
	get: return _current_attack.get_child_count() if _current_attack else 0

## Attack that will be performed next
var current_attack: UnitAttack:
	get:
		if alternative_action_index <= 0: return _current_attack
		if alternative_action_count < alternative_action_index: return _current_attack
		return _current_attack.get_children()[alternative_action_index - 1]
	set(value):
		_current_attack = value
		alternative_action_index = 0

## Attacks left to perform this round
var attacks_for_this_round: Array[UnitAttack]

## Indicates if unit is in a defense stance. [br]
## This flag has only one job - to cut incoming damage in half.
## @experimental: This behavior is a legacy from Disciples and may be a subject to future changes.
var defense_stance: bool = false

## @experimental: This behavior is a legacy from Disciples and may be a subject to future changes.
## Indicates if this unit is in the procces of skipping turn.
## Needed for the sync reasons: when the attack is to be skipped,
## the player won't be prompted to chose a target. Also, this flag makes the skipping attack
## independent of the attack itself. [br]
## Potential features: skipping sevral turns or skipping a particular attack.
var skipping_turn: bool = false

## If [code]true[/code], unit doesn't leave corpse after death (the object is comletely deleted).
var summoned_unit: bool = false

var active: bool = false

## Reference to the original [UnitData] object used to initialize this unit instance.
## If this reference is lost, the unit cannot update health, experience,
## and other persistent parameters after combat concludes.
var original_data: UnitData = null

var current_xp: int:
	get: return original_data.current_xp if original_data else 0

const LEVELUP_EFFECT = preload("uid://bdxoklt2vs33j")

#endregion

#region API

func _read_data(data: UnitData) -> void:
	original_data = data.original if data.original else data
	unit_name = data.personal_name if data.personal_name else unit_name
	needed_xp = data.needed_xp
	unit_type = data.unit_type
	faction = data.faction
	full_description = data.description

func _visualize_evolution(data: UnitData) -> void:
	if parameters.dead: return
	var s := spot
	spot.release_unit()
	s.add_unit(load(data.scene_path), data)
	s.add_child(LEVELUP_EFFECT.instantiate())
	queue_free()

func _check_evolution(data: UnitData, prev: StringName) -> void:
	if data == original_data: _visualize_evolution.call_deferred(data)

## Initializes unit variables and connects signals. Safe to call multiple times. [br]
## [param data] can be set to null: the data is ignored in this case. [br]
## [b]Returns:[/b] whether initialization was successful or not.
func initialize_variables(data: UnitData) -> bool:
	if initialized:
		return true
	parameters = get_node("UnitParameters")
	party = spot.get_parent() as Party
	system = party.main_system
	
	if not parameters.initialize_variables(data):
		return false
	
	if data: _read_data(data)
	
	EventBus.turn_ended.connect(reset_chosen_targets)
	EventBus.turn_ended.connect(clean_effects)
	EventBus.round_started.connect(arrange_attacks_and_set_next)
	EventBus.attack_reached.connect(check_taking_damage)
	EventBus.unit_evolved.connect(_check_evolution)
	
	if parameters.dead:
		spot.move_unit_to_graveyard()
		animation_handle.pause()
		visible = false
	initialized = true
	return true

## Clears references to objects that are used only once (e.g. Attacks)
func clear_objects() -> void:
	clean_effects()
	warded_attacks.clear()

## Cleans applied effects: removes dead references, removes unapplied icons. [br]
## [param _unit] doesn't do anythig, it's only there to connect this method to signals
## that have this parameter as part of their signatures
func clean_effects(_unit: Unit = null) -> void:
	var _displayed_icons := displayed_icons
	displayed_icons = {}
	for icon: TextureRect in _displayed_icons:
		if is_instance_valid(_displayed_icons[icon]):
			displayed_icons[icon] = _displayed_icons[icon]
			icon.visible = not (_displayed_icons[icon] as AppliedEffect).silenced
			continue
		icon.queue_free()
	
	parameters.clean_modifiers()


## Attempts to register a target for attack. Returns success or failure.
func give_target(_spot: UnitSpot) -> bool:
	if parameters.dead: return false
	if current_attack == null:
		if attacks_for_this_round.is_empty():
			return false
		set_next_attack()
	if chosen_spots.size() >= current_attack.targets_needed:
		return false
	var is_target_valid: bool = current_attack.target_validation.validate_target(self, _spot)
	if not is_target_valid:
		return false
	chosen_spots.append(_spot)
	if chosen_spots.size() == current_attack.targets_needed:
		start_attacking()
	return true

## Skips an attack and sets the next one
func skip_attack(message: String = "", color: Color = Color.WHITE) -> void:
	skipping_turn = true
	reset_chosen_targets(self)
	set_next_attack()
	if message != "":
		system.display_text_near_unit(self, message, color)
	
	var signal_next_stage := get_tree().create_timer(SKIP_DELAY).timeout
	signal_next_stage.connect(system.combat_logic.next_stage)
	signal_next_stage.connect(
		func() -> void:
			skipping_turn = false
	)

func try_switch_action() -> bool:
	if not current_attack: return false
	var possible_action_count := _current_attack.get_child_count()
	if possible_action_count == 0: return false
	alternative_action_index += 1
	if alternative_action_index > possible_action_count:
		alternative_action_index = 0
	reset_chosen_targets(self)
	return true

#endregion

#region Recieving attacks

var warded_attacks: Array[Attack] = []

## Updates unit visuals using the most recent snapshot from [member parameter_snapshots].
## Typically called automatically when [signal EventBus.attack_reached] is emitted.
func finalize_attack() -> void:
	if not parameter_snapshots: return
	var snapshot: UnitParametersSnapshot = parameter_snapshots.pop_front()
	if not snapshot: return
	
	var last_hp: int = int(visual_bar.value)
	var last_ratio: float = visual_bar.value / visual_bar.max_value
	
	var new_hp: int = snapshot.hp
	var new_ratio: float = float(snapshot.hp) / float(snapshot.max_hp)
	
	if not is_equal_approx(new_ratio, last_ratio) and last_hp != new_hp:
		display_damage(last_hp - new_hp, snapshot.message, snapshot.color)
	
	visual_bar.max_value = snapshot.max_hp
	visual_bar.value = snapshot.hp

## Processes an attack against this unit, applying damage calculations immediately.
## This method handles game logic but does not update visuals -
## it calls [method schedule_damage] for visual sequencing,
## unless [param finalize] is set to [code]true[/code].
func resolve_attack(attack: Attack, damage: int, delay: int = 0, finalize: bool = false) -> void:
	if attack.evadable and GlobalDefs.rand_roll(clampf(parameters.evasion, 0.0, 1.0), party):
		EventBus.attack_evaded.emit(self, attack)
		system.display_text_near_unit(self, "Evaded!")
		sound_player.play_evade_sound()
		attack.tags.append(&"evaded")
		return
	
	for effect_name: String in attack.applying_effects:
		parameters.apply_effect(
			effect_name.to_lower(),
			attack.applying_effects[effect_name]
		)
	
	var damage_taken: int = (
			heal(damage) if finalize else \
			schedule_heal(damage, delay)
		) if attack.is_heal else(
			take_damage(damage) if finalize else \
			schedule_damage(damage, delay)
		)
	
	attack.register_applied_damage(self, damage_taken)
	
	# if unit is dead after taking damage, it was killed by this attack
	if parameters.dead:
		EventBus.unit_killed.emit(self, attack.attacker)

## Called when [member EventBus.attack_reached] is emitted.
func check_taking_damage(unit: Unit) -> void:
	finalize_attack()

#endregion

#region Delivering attacks


## Resets attack targets and emits a signal that the attack has finished.
func finish_attacking() -> void:
	reset_chosen_targets(self)
	set_next_attack()
	EventBus.attack_animation_finished.emit(self)
	#EventBus.attack_concluded.emit(self)


## Set to false when you need to skip next call of [method set_next_attack]
var attack_setting: bool = true

## Assigns next current_attack if possible
func set_next_attack() -> void:
	if not attack_setting:
		attack_setting = true
		return
	
	current_attack = null
	if attacks_for_this_round.size() > 0:
		current_attack = attacks_for_this_round.pop_front()


## Clears chosen targets for the unit if it matches the provided unit.
## The argument here serves only to filter signal emits that could be triggered by other units
func reset_chosen_targets(_unit: Unit) -> void:
	if _unit == self:
		chosen_spots.clear()


## Sets [member attacks_for_this_round] to its default value.
## Used at the start of the game, when assets are being initialized.
func arrange_attacks() -> void:
	attacks_for_this_round = parameters.attacks.duplicate()

## Sets [member attacks_for_this_round] to its default value and sets [member current_attack].
## Used at the start of a new round.
func arrange_attacks_and_set_next() -> void:
	arrange_attacks()
	set_next_attack()

#endregion


#region Combat actions

## @experimental: if [member UnitParameters.shielding] is set to [code]false[/code], the chance is cut in half
func attempt_shielding(attack: Attack, unit: Unit) -> void:
	if not unit: return
	var chance := parameters.shielding_chance if parameters.shielding else \
		parameters.shielding_chance / 2
	
	if not GlobalDefs.rand_roll(chance, party): return
	
	system.display_text_near_unit(self, "Shield!")
	# if double shield attempt, split the damage
	if &"shielded" in attack.tags:
		attack.default_damage /= 2
		for t:UnitSpotReference in attack.damages:
			attack.damages[t] /= 2
		attack.damages[UnitSpotReference.new(spot)] = attack.default_damage
		return
	
	attack.tags.append(&"shielded")
	attack.redirect_all(unit.spot, spot)
	
	EventBus.attack_shielded.emit(attack, self)

func _force_native_attack(target: Unit, attack: UnitAttack = null) -> Attack:
	if attack == null:
		attack = current_attack
	if attack == null or \
			not \
			( \
				attacks_for_this_round.has(attack) or \
				current_attack == attack \
			):
		return null
	
	var atk: Attack = create_attack(attack, [target.spot])
	
	system.combat_logic.remove_attack_from_queue(attack)
	
	return atk

func _force_arbitrary_attack(target: Unit, attack: UnitAttack) -> Attack:
	if attack == null:
		attack = current_attack
	if attack == null:
		return null
	
	var atk: Attack = create_attack(attack, [target.spot])
	
	return atk

## Forces a unit to perform the specified [param attack] on [param target],
## bypassing target validation and the normal attack order.[br][br]
## If [param native_attack] is set to [code]true[/code]:[br]
## * The unit will only attack if [param attack] is one of its own attacks or [code]null[/code].[br]
## * If [param attack] is [code]null[/code], the unit uses its closest available attack, if any.[br]
## * Performed attack is removed from the attack queue.[br][br]
## If [param native_attack] is set to [code]false[/code], the attack is performed "out of nowhere,"
## meaning it is not removed from any lists and is not removed from the queue.
## If [param attack] is [code]null[/code], the unit uses a copy of its closest available attack.
func force_attack(target: Unit, native_attack: bool = true, attack: UnitAttack = null) -> void:
	var atk: Attack = null
	
	if native_attack:
		atk = _force_native_attack(target, attack)
	else:
		atk = _force_arbitrary_attack(target, attack)
		if atk != null:
			# set flag to skip set_next_attack() when the forced attack is finished
			attack_setting = false
	
	if atk == null:
		return
	
	atk.tags.append(&"forced")
	if unit_type == GlobalDefs.UnitType.Archer:
		atk.tags.append(&"shot")
	
	animation_handle.play_attack_animation(atk.unit_attack.animation_index)
	system.combat_logic.book_damage(atk)

## Initiates an attack based on the chosen targets.
func start_attacking() -> void:
	if chosen_spots.is_empty():
		return
	defense_stance = false
	parameters.shielding = false
	animation_handle.play_attack_animation(current_attack.animation_index)
	
	var attack: Attack = create_attack(current_attack, chosen_spots.duplicate())
	if unit_type == GlobalDefs.UnitType.Archer:
		attack.tags.append(&"shot")
	
	system.combat_logic.book_damage(attack)

## Returns if it was possible and thereby the unit has taken defense stance
func try_take_defense_stance() -> bool:
	if now_attacking():
		return false
	defense_stance = true
	if unit_type == GlobalDefs.UnitType.Melee: parameters.shielding = true
	set_next_attack()
	system.display_text_near_unit(self, "Defending")
	return true

## Returns if it was possible and thereby the unit's attack is moved to the end of queue
func try_waiting() -> bool:
	if now_attacking():
		return false
		
	attacks_for_this_round.append(current_attack)
	set_next_attack()
	
	system.display_text_near_unit(self, "Waiting...")
	return true
#endregion

#region Combat interactions

# ATTENTION: prone to memory leaks
## Hides the unit and disables all interactions. To reactivate, use
## [method UnitSpot.assign_unit] on the spot where this unit should be placed
## upon reactivation. [br][br]
## [color=red]Warning: This method makes the [Unit] object an [i]orphan*[/i] without
## reserving any references to it![/color][br]
## The caller is responsible for storing a reference
## to the deactivated unit and either reactivating it later or freeing the memory.[br]
## *An [i]orphan[/i] is a node outside the [SceneTree]. Creating orphans without
## maintaining references causes memory leaks since Godot's garbage collector
## does not handle [Node] objects.
func deactivate() -> void:
	active = false
	if spot: spot.release_unit()
	system.combat_logic.remove_unit_from_queue(self)

## Equivalent to setting [member active] to [code]true[/code].[br]
## Do not call this method directly - use [method UnitSpot.assign_unit]
## on the target spot where this unit should be placed during reactivation.
func activate() -> void:
	if active: return
	active = true

func resurrect(message: String = "Revived!") -> void:
	var sp := get_parent().get_parent()
	if sp is UnitSpot:
		if spot.unit != null:
			return
	else:
		push_error("Trying to revive a unit that doesn't have a UnitSpot as a grandparent!")
		return
	
	get_parent().remove_child(self)
	
	parameters.underlying_HP = 1
	parameters.dead = false
	sp.assign_unit(self)
	visible = true
	death_visualized = false
	animation_handle.play(&"default")
	
	for effect in parameters.get_all_effects():
		effect.activate()
	
	system.display_text_near_unit(self, message)
	EventBus.unit_revived.emit(self)

## Restores health to the unit and plays associated animations and sounds. [br]
## Returns the actual amount of health restored (may differ from the provided value
## due to effects, randomization, or other modifiers). [br]
## Negative values deal damage instead - returns zero in this case.[br]
## [color=red]Warning:[/color] this method does not allow animation synchronization.
## Use [method schedule_heal] instead.
func heal(value: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> int:
	if value == 0:
		return 0
	if value < 0:
		take_damage(-value)
		return 0
	
	var hp_healed: int = parameters.heal(value)
	display_heal(hp_healed, message, text_color)
	return hp_healed

## [b]Returns:[/b] the actual amount of health restored (may differ from the provided
## value due to effects, randomization, or other modifiers).[br]
## Negative values deal damage instead - returns zero in this case.[br][br]
## Schedules an entry in [member parameter_snapshots] for later visualization.
## See [method schedule_damage] for reference.
func schedule_heal(
	value: int, 
	delay: int, 
	message: String = "", 
) -> int:
	if delay <= 0: return heal(value, message)
	var healed: int = parameters.heal(value)
	
	while parameter_snapshots.size() < delay-1:
		parameter_snapshots.append(null)  # add padding as delay
	
	parameter_snapshots.append(
		UnitParametersSnapshot.new(parameters, message, HEAL_COLOR)
	)
	return healed


const MIN_DAMAGE_COLOR = Color(0.7, 0.7, 1.0)
const MAX_DAMAGE_COLOR = Color(1.0, 0.1, 0.1)
const HEAL_COLOR = Color.LIME_GREEN


## Returnes interpolated color between [member MIN_DAMAGE_COLOR] and [member MAX_DAMAGE_COLOR]
## with the factor of damage dealt as a percentage of total health
func damage_color(dmg: int) -> Color:
	var damage_percentage: float = float(dmg) / float(parameters.max_hp)
	damage_percentage = clampf(damage_percentage, 0.0, 1.0)
	return MIN_DAMAGE_COLOR.lerp(MAX_DAMAGE_COLOR, damage_percentage)


## Applies damage to the unit and triggers associated animations bypassing armor. [br]
## For argument reference see [method take_damage] [br]
## [color=pink]Warning:[/color] this method does not allow animation synchronization.
func take_direct_damage(
	dmg: int,
	message: String = "",
	text_color: Color = Color.TRANSPARENT,
	flags: Array[StringName] = []
) -> void:
	if dmg <= 0: return
	
	var damage_taken := parameters.take_direct_damage(dmg, false)
	animation_handle.play_damage_animation(message)
	if message != "":
		message += ": %d" % dmg
	
	var color := text_color if \
			text_color != Color.TRANSPARENT else \
			damage_color(damage_taken)
	
	system.display_text_near_unit(
			self,
			message,
			color
	)

## Applies damage to the unit and triggers associated animations.[br]
## [param dmg] is damage that is to be taken by unit.[br]
## [param message] is message that will be displayed near the number.[br]
## [param text_color] is color of the text. If left as Color.TRANSPARENT,
## color is detemined by calling [method damage_color].[br]
## Returns: the actual amount of health lost (may differ from the provided
## value due to effects, randomization, or other modifiers). [br]
## [color=red]Warning:[/color] this method does not allow animation synchronization.
## Use [method schedule_damage] instead.
func take_damage(
	dmg: int,
	message: String = "",
	text_color: Color = Color.TRANSPARENT,
	flags: Array[StringName] = []
) -> int:
	if dmg == 0:
		return 0
	if dmg < 0:
		heal(-dmg)
		return 0
	
	var damage_taken := parameters.take_damage(dmg)
	display_damage(damage_taken, message, text_color)
	return damage_taken

## [b]Returns:[/b] the actual amount of health lost (may differ from the provided
## value due to effects, randomization, or other modifiers).[br]
## Negative values heal instead - returns zero in this case.[br][br]
## Schedules a damage entry in [member parameter_snapshots] for later visualization.
## The damage will be finalized when [signal EventBus.attack_reached] is emitted, or
## manually by calling [method finalize_attack].[br]
## [param dmg] is damage that is to be taken by unit.[br]
## [param delay]: Number of [signal EventBus.attack_reached] triggers before 
## visualizing the damage. [color=yellow]Note:[/color] Count starts at 1 - value
## of zero triggers animation immediately.[br]
## [param message] is message that will be displayed near the number.[br]
## [param text_color] is color of the text. If left as Color.TRANSPARENT,
## color is detemined by calling [method damage_color].[br][br]
## Example sequence:
## [codeblock]
## unit.schedule_damage(10, 1) # Health reduced by ~10 internally, no visual change yet
## unit.schedule_damage(20, 2) # Health reduced by ~30 internally, no visual change yet
## [/codeblock]
## [codeblock]
## EventBus.attack_reached.emit(unit) # Visuals update to show ~10 damage
## EventBus.attack_reached.emit(unit) # Visuals update to show ~30 total damage
## [/codeblock]
## Manual delay calculation is unnecessary - the snapshot is appended to the end of
## [member parameter_snapshots]. Padding is automatically added if needed to achieve
## the requested delay, but if the list is already longer, it's simply appended.[br]
## This example produces identical results to the previous one:
## [codeblock]
## unit.schedule_damage(10, 1)
## unit.schedule_damage(20, 1) # No need to increment delay for sequential damage
## # unit.schedule_damage(30, 0) # Avoid 0 delay - triggers immediate visualization
## [/codeblock]
func schedule_damage(
	dmg: int, 
	delay: int, 
	message: String = "", 
	text_color: Color = Color.TRANSPARENT
) -> int:
	if delay <= 0: return take_damage(dmg, message, text_color)
	var damage_taken: int = parameters.take_damage(dmg)
	
	while parameter_snapshots.size() < delay-1:
		parameter_snapshots.append(null)  # add padding as delay
	
	parameter_snapshots.append(
		UnitParametersSnapshot.new(parameters, message, text_color)
	)
	return damage_taken

func display_heal(dmg: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> void:
	if dmg == 0: return
	if dmg < 0: display_damage(-dmg, message, text_color)
	
	if message != "":
		message += ": "
	message += "+" + str(dmg)
	
	var color := text_color if \
			text_color != Color.TRANSPARENT else \
			HEAL_COLOR
	
	animation_handle.play_heal_animation()
	system.display_text_near_unit(self, message, color)
	update_visuals()

## Displays a damage number and triggers damage animation. [br]
## If [param text_color] is not specified, color is determined by calling [method damage_color]
func display_damage(dmg: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> void:
	if dmg == 0: return
	if dmg < 0: display_heal(-dmg, message, text_color)
	
	if message != "":
		message += ": "
	message += "-" + str(dmg)
	
	var color := text_color if \
			text_color != Color.TRANSPARENT else \
			damage_color(dmg)
	
	animation_handle.play_damage_animation(message)
	system.display_text_near_unit(self, message, color)

var death_visualized: bool = false

func die() -> void:
	if not initialized:
		return
	if death_visualized: return
	
	EventBus.unit_died.emit(self)
	animation_handle.play_death_animation()
	sound_player.play_death_sound()
	
	#party.units[party_position] = null
	spot.move_unit_to_graveyard()
	death_visualized = true
	for effect in parameters.get_all_effects():
		effect.deactivate()

#endregion

## Updates the unit's visual representation to match current parameter values.
## Resets [member parameter_snapshots], triggers death animation if applicable.
func update_visuals() -> void:
	if death_visualized: return
	visual_bar.max_value = parameters.max_hp
	visual_bar.value = parameters.hp
	parameter_snapshots.clear()
	if parameters.dead: die()

#region Global Interaction

## Adds a new effect to the [member original_data] for persistence between battles. [br]
## This method performs no validation - duplicate effects may be added without checks.
func add_persistent_effect(effect: AppliedEffect) -> void:
	if not original_data: return
	original_data.add_effect(effect)

#endregion

#region Utilities

## Creates an [Attack] object and returns it. [br][br]
## [b]Note:[/b] This method modifies the provided [param targets] array.
## Use [method Array.duplicate] if the original array must remain unchanged.
func create_attack(unit_attack: UnitAttack, targets: Array[UnitSpot]) -> Attack:
	if unit_attack.additional_targets:
		targets.append_array(
			unit_attack.additional_targets.\
				find_additional_targets(self, targets)
		)
	
	var attack: Attack = Attack.new(
		unit_attack,
		targets,
		parameters.get_actual_damage(unit_attack),
		parameters.attack_effect
	)
	
	#atck_ref = weakref(attack)
	
	if unit_attack.damage_policy:
		attack.damage_policy = unit_attack.damage_policy
	if not unit_attack.applying_effects.is_empty():
		attack.applying_effects = unit_attack.applying_effects
	
	return attack

#var atck_ref: WeakRef
#var __debug_timer: float = 2.0
#func __debug_track_ref() -> void:
	#if atck_ref.get_ref():
		#print("leak?")
#
#func _process(delta: float) -> void:
	#if not atck_ref: return
	#__debug_timer -= delta
	#if __debug_timer <= 0.0:
		#__debug_track_ref()
		#__debug_timer = 1.0

const XP_FACTOR_HP = 0.25
const XP_FACTOR_DMG = 0.5

func get_xp_for_killing() -> int:
	var hp_xp := int(parameters.max_hp * XP_FACTOR_HP)
	var dmg_xp := int(parameters.get_full_damage() * XP_FACTOR_DMG)
	return hp_xp + dmg_xp

func now_attacking() -> bool:
	if not chosen_targets.is_empty():
		return true
	if animation_handle.now_attacking:
		return true
	return false

func display_effect_icon(image: Image, effect: AppliedEffect) -> void:
	clean_effects()
	var texture_rect: TextureRect = TextureRect.new()
	effect_icons_container.add_child(texture_rect)
	texture_rect.texture = ImageTexture.create_from_image(image)
	texture_rect.scale = Vector2(EFFECT_ICONS_SCALE, EFFECT_ICONS_SCALE)
	displayed_icons[texture_rect] = effect


func visualize_death() -> void:
	if summoned_unit:
		queue_free()
		return
	
	visible = false

#endregion



class UnitParametersSnapshot:
	var hp: int
	var max_hp: int
	var message: String
	var color: Color
	#var dead: bool
	func _init(params: UnitParameters, msg: String, col: Color) -> void:
		hp = params.hp
		max_hp = params.max_hp
		message = msg
		color = col
