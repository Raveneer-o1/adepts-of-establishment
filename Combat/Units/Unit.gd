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
## This means populating [member taking_damage_attacks] and [member taking_damage_delays] as necessary.
## This is to sync animations: when the animation reaches active frame, [method finilize_attack]
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
## [br]
##
## [b]Shielding[/b] is a mechanic that allows units in the front line to protect units in
## the back. When a unit [i]shields[\i], every attack with a tag [code]&shot[\code] 
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
## Note: any other field or effect has a priority over this ruleset.
@export var unit_type: GlobalDefs.UnitType
@export_multiline var brief_description: String
@export_multiline var full_description: String
@export var portrait_texture: Texture2D
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

## flag is used during the initialization exclusively. 
## It's here to prevent calling error-prone functions before the object is fully initialized.
## This is required because sometimes units are added during the combat.
## And it may cause problems without this check.
var initialized: bool = false

var displayed_icons: Dictionary[TextureRect, AppliedEffect]

## Position in the party. Even numbers represent fron line, odd numbers - back line.
## Position is also index of this unit in the [member Party.units]
var party_position: int

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

## Attack that will be performed next
var current_attack: UnitAttack
## Attacks left to perform this round
var attacks_for_this_round: Array[UnitAttack]

## Indicates if unit is in a defense stance. [br]
## This flag has only one job - to cut incoming damage in half.
## @experimental: This behavior is a legacy from Disciples and may be a subject to future changes.
var defense_stance: bool = false


## Indicates if this unit is in the procces of skipping turn.
## Needed for the sync reasons: when the attack is to be skipped,
## the player won't be prompted to chose a target. Also, this flag makes the skipping attack
## independent of the attack itself
## @experimental: This behavior is a legacy from Disciples and may be a subject to future changes.
## For example, skipping sevral turns or skipping a particular attack.
var skipping_turn: bool = false

## If [code]true[/code], unit doesn't leave corpse after death (the object is comletely deleted).
var summoned_unit: bool = false

#endregion

#region API

## Initializes unit variables and connects signals.
func initialize_variables() -> bool:
	if initialized:
		return true
	parameters = get_node("UnitParameters")
	party = get_parent().get_parent() as Party
	system = party.main_system
	if party == null:
		print_debug("Unable to find Party node!")
	
	if not parameters.initialize_variables():
		return false
	
	EventBus.turn_ended.connect(reset_chosen_targets)
	EventBus.turn_ended.connect(clean_effects)
	EventBus.round_started.connect(arrange_attacks_and_set_next)
	EventBus.attack_reached.connect(check_taking_damage)
	
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
	if current_attack == null:
		if attacks_for_this_round.is_empty():
			return false
		set_next_attack()
	if chosen_spots.size() >= current_attack.targets_needed:
		return false
	var is_target_valid: bool = current_attack.target_validation._validate_target(self, _spot)
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
	EventBus.turn_ended.connect(
		func(_unit: Unit) -> void:
			skipping_turn = false
	)


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
## it calls [method schedule_damage] for visual sequencing.
func resolve_attack(attack: Attack, damage: int, delay: int = 0, finalize: bool = false) -> void:
	if attack.type != GlobalDefs.AttackType.None and \
			parameters.immunities.has(attack.type):
		system.display_text_near_unit(self, "Immunity")
		sound_player.play_immunity_sound()
		return
	
	# checking shield before miss/evade because warded_attacks is already filled 
	# at this point and 'ward' effect is removed
	if warded_attacks.has(
			attack.original.get_ref() if attack.original else attack
		):
			system.display_text_near_unit(self, "Shield!")
			sound_player.play_shield_sound()
			return
		
	
	if attack.accuracy < randf():
		system.display_text_near_unit(self, "Miss!")
		EventBus.attack_missed.emit(self, attack)
		attack.attacker.sound_player.play_miss_sound()
		return
	
	if attack.evadable:
		# recalculate random number to remove any numerical connection with accuracy
		if parameters.evasion > randf():
			EventBus.attack_evaded.emit(self, attack)
			system.display_text_near_unit(self, "Evaded!")
			sound_player.play_evade_sound()
			return
	
	# apply effects if any are present
	if not attack.applying_effects.is_empty():
		for effect_name: String in attack.applying_effects:
			parameters.apply_effect(
				effect_name.to_lower(),
				attack.applying_effects[effect_name]
			)
	
	var damage_taken: int = parameters.take_damage(damage)
	if damage_taken > 0: sound_player.play_damage_sound()
	
	if attack.original:
		attack.original.get_ref().applied_damage += damage_taken;
	else:
		attack.applied_damage += damage_taken;
	
	# if untit is dead after taking damage, it was killed by this attack
	if parameters.dead:
		EventBus.unit_killed.emit(self, attack.attacker)
	
	if finalize or delay <= 0: take_damage(damage_taken)
	else: schedule_damage(damage_taken, delay)


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
		chosen_targets = []
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

func attempt_shielding(attack: Attack, unit: Unit) -> void:
	if not parameters.shielding: return
	if not unit: return
	
	if randf() > parameters.shielding_chance: return
	
	system.display_text_near_unit(self, "Shield!")
	# if double shield attempt, split the damage
	if &"shielded" in attack.tags:
		attack.default_damage /= 2
		for t:UnitSpotReference in attack.damages:
			attack.damages[t] /= 2
		attack.damages[UnitSpotReference.new(spot)] = attack.default_damage
		return
	
	attack.tags.append(&"shielded")
	#var ref: UnitSpotReference = attack.find_reference()
	#assert(ref, "Unit not found in the attack dictionary!")
	attack.redirect_all(unit.spot, spot)

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
## * If [param attack] is [code]null[/code], the unit uses its closest available attack, if any.[br][br]
## * Performed attack is removed from the attack queue.[br]
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
	
	sound_player.play_attack_sound()
	animation_handle.play_attack_animation()
	system.combat_logic.book_damage(atk)

## Initiates an attack based on the chosen targets.
func start_attacking() -> void:
	if chosen_spots.is_empty():
		return
	defense_stance = false
	parameters.shielding = false
	animation_handle.play_attack_animation()
	
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

func resurrect() -> void:
	var sp := get_parent().get_parent()
	if sp is UnitSpot:
		if spot.unit != null:
			return
		spot = sp
	else:
		print_debug("Trying to resurrect a unit that doesn't have a UnitSpot as a grandparent!")
		return
	
	get_parent().remove_child(self)
	
	parameters.underlying_HP = 1
	parameters.dead = false
	spot.assign_unit(self)
	visible = true
	animation_handle.play(&"default")
	
	system.display_text_near_unit(self, "Resurrected!")
	EventBus.unit_revived.emit(self)

## Restores health to the unit and triggers associated animations.
func heal(value: int) -> int:
	if value == 0:
		return 0
	if value < 0:
		take_damage(-value)
		return 0
	
	var hp_healed: int = parameters.heal(value)
	display_heal(value)
	return hp_healed


const MIN_DAMAGE_COLOR = Color.WEB_MAROON
const MAX_DAMAGE_COLOR = Color.RED
const HEAL_COLOR = Color.LIME_GREEN


## Returnes interpolated color between [member MIN_DAMAGE_COLOR] and [member MAX_DAMAGE_COLOR]
## with the factor of damage dealt as a percentage of total helth
func damage_color(dmg: int) -> Color:
	var damage_percentage: float = float(dmg) / float(parameters.max_hp)
	damage_percentage = clampf(damage_percentage, 0.0, 1.0)
	return MIN_DAMAGE_COLOR.lerp(MAX_DAMAGE_COLOR, damage_percentage)


## Applies damage to the unit and triggers associated animations bypassing armor. [br]
## For parameter reference see [method take_damage] [br]
## [color=red]Warning:[/color] this method does not allow animation synchronization.
## Use [method schedule_damage] instead.
func take_direct_damage(dmg: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> void:
	if dmg <= 0: return
	
	var damage_taken := parameters.take_direct_damage(dmg)
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
## [color=red]Warning:[/color] this method does not allow animation synchronization.
## Use [method schedule_damage] instead.
func take_damage(dmg: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> int:
	if dmg == 0:
		return 0
	if dmg < 0:
		heal(-dmg)
		return 0
	
	var damage_taken := parameters.take_damage(dmg)
	display_damage(dmg, message, text_color)
	return damage_taken

## Schedules a damage entry in [member parameter_snapshots] for later visualization.
## The damage will be finalized when [signal EventBus.attack_reached] is emitted, or
## manually by calling [method finalize_attack]. Returns the damage taken.
func schedule_damage(
	dmg: int, 
	delay: int, 
	message: String = "", 
	text_color: Color = Color.TRANSPARENT
) -> int:
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

func die() -> void:
	if not initialized:
		return
	
	EventBus.unit_died.emit(self)
	animation_handle.play_death_animation()
	
	party.units[party_position] = null
	spot.move_unit_to_graveyard()

#endregion


#region Display text


## Interval for the first text to be displayed after triggering
const FIRST_TEXT_DISPLAYED_INTERVAL = 0.1
## Default interval between consecutive text displays
const TEXT_DISPLAYED_INTERVAL = 0.55
## Interval after which text display process is aborted
const TEXT_DISPLAYED_ABORT_INTERVAL = TEXT_DISPLAYED_INTERVAL * 2

## Tracks whether any text was recently displayed
var text_displayed: bool = false
## Timer for how long text display has been active or idle
var text_displayed_time: float = TEXT_DISPLAYED_ABORT_INTERVAL


## A class representing text to be displayed near a unit
class DisplayedText:
	var unit: Unit
	var text: String
	var color: Color = Color.WHITE
	
	func _init(u: Unit, t: String, c: Color = Color.WHITE) -> void:
		unit = u
		text = t
		color = c


## Queue of texts to be displayed, each associated with a specific unit
var texts_to_display: Array[DisplayedText] = []


## Adds a vanishing message near a unit and starts the display process
func display_text_near_unit(text: String, color: Color = Color.WHITE) -> void:
	# Create a new text object and add it to the queue
	var text_to_display: DisplayedText = DisplayedText.new(self, text, color)
	texts_to_display.append(text_to_display)
	
	# Start the display process if no text is currently being displayed
	if not text_displayed:
		text_displayed = true
		get_tree().create_timer(FIRST_TEXT_DISPLAYED_INTERVAL).\
				timeout.connect(display_next_text)



## Displays a text label near the given unit. It's not recommended to use this method,
## because it's possible to print too much text on the screen at the same time
func _display_text_near_unit(d_text: DisplayedText) -> void:
	text_displayed = true  # Mark text as being displayed
	text_displayed_time = TEXT_DISPLAYED_ABORT_INTERVAL  # Reset abort timer
	
	# Define label offset and create a temporary label
	var offset := system.label_position
	var lbl: Label = system.TEMP_LABEL.instantiate()
	d_text.unit.add_child(lbl) # Attach the label as a child to the unit
	
	# Set label properties (text, position, color)
	lbl.text = d_text.text
	lbl.set_begin(d_text.unit.global_position + offset)
	lbl.modulate = d_text.color

func display_next_text_out() -> void:
	display_next_text()

## Displays the next queued text and handles overlap between units
func display_next_text() -> void:
	# If no text is queued, reset display flags and timer
	if texts_to_display.is_empty():
		text_displayed = false
		text_displayed_time = TEXT_DISPLAYED_ABORT_INTERVAL
		return
	
	# Display the next text in the queue
	var next_text: DisplayedText = texts_to_display.pop_front()
	_display_text_near_unit(next_text)
	
	
	# Schedule the next text display
	get_tree().create_timer(TEXT_DISPLAYED_INTERVAL). \
			timeout.connect(display_next_text_out)


#endregion


func update_visuals() -> void:
	visual_bar.max_value = parameters.max_hp
	visual_bar.value = parameters.hp
	parameter_snapshots.clear()
	if parameters.dead: die()

#region Utilities

## Creates an [Attack] object and returns it
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
	
	if unit_attack.damage_policy:
		attack.damage_policy = unit_attack.damage_policy
	if not unit_attack.applying_effects.is_empty():
		attack.applying_effects = unit_attack.applying_effects
	
	return attack

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


func _process(delta: float) -> void:
	if text_displayed:
		text_displayed_time -= delta
		if text_displayed_time <= 0:
			print_debug("Interval missed on unit %s! Aborting display interval..." % unit_name)
			text_displayed = false
			text_displayed_time = TEXT_DISPLAYED_ABORT_INTERVAL
			texts_to_display.clear()


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
