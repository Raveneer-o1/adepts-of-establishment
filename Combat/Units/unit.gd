class_name Unit
extends Node2D

## Core class for all combat units.
## Handles interactions with the combat system and delegates tasks to helper classes
## (e.g., animations and parameters).
##
## The Unit class is a highly flexible framework for characters in the combat system, 
## supporting diverse mechanics and behaviors. Each unit has customizable parameters stored in a shared database, 
## along with a list of actions defined by the [UnitAttack] class, which handles target validation and optional 
## custom damage logic. Effects, implemented as modular nodes, can dynamically modify a unit's stats or behavior 
## and are automatically removed when expired. This design enables easy creation of unique unit types through 
## subclassing and composition, allowing specialized mechanics without significant code duplication. 


const EFFECT_ICONS_SCALE = 0.75
## Delay in seconds between proccesing skip turn and pocceding to the next stage
const SKIP_DELAY = 0.4


#region Export variables

@export var unit_name: String
## Type of a unit is primarily used by AI
@export_enum("Healer", "Warrior", "Defender", "Buffer", "Debuffer", "Archer", "Mage") var unit_type: String
@export_multiline var brief_description: String
@export_multiline var full_description: String
@export var portrait_texture: Texture2D
#endregion


@onready var animation_handle: UnitAnimationsHandle = get_node("AnimationHandle")
@onready var spot: UnitSpot = get_parent()
@onready var effect_icons_container: HBoxContainer = $EffectIconsContainer


#region Variables

# Associated components and metadata
var parameters: UnitParameters
var party: Party
var system: CombatSystem


var initialized: bool = false

## <TextureRect, AppliedEffect>
var displayed_icons: Dictionary

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


## Alredy resolved attacks waiting to apply damage.
## Damage is applied when [member EventBus.attack_reached] is emitted.
## When [member EventBus.attack_finished] is emitted,
## all attacks in this list are immediately finalized
var taking_damage_attacks: Array[Attack] = []
## Every time [member EventBus.attack_reached] is emitted, all delays in this list areredused by 1.
## If the first element is 0, finalizes closest attack from [code]taking_damage_attacks[/code]
var taking_damage_delays: Array[int] = []

## Indicates if unit is in a defense stance
var defence_stance: bool = false

## Indicates if this unit is in the procces of skipping turn
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
	EventBus.attack_animation_finished.connect(finalize_all_attacks)
	
	initialized = true
	return true

## Clears references to objects that are used only once (e.g. Attacks)
func clear_objects() -> void:
	clean_effects()
	shielded_attacks.clear()

## Cleans applied effects: removes dead references, removes unapplied icons. [br]
## [param _unit] doesn't do anythig, it's only there to connect this method to signals
## that have this parameter as part of their signatures
func clean_effects(_unit: Unit = null) -> void:
	var _displayed_icons := displayed_icons
	displayed_icons = {}
	for icon: TextureRect in _displayed_icons:
		if is_instance_valid(_displayed_icons[icon]):
			displayed_icons[icon] = _displayed_icons[icon]
			if (_displayed_icons[icon] as AppliedEffect).silenced:
				icon.visible = false
			else:
				icon.visible = true
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


## Applies damages from all taking_damage_attacks
func finalize_all_attacks(_unit: Unit) -> void:
	while taking_damage_attacks.size() > 0:
		finalize_attack()
	taking_damage_delays.clear()


var shielded_attacks: Array[Attack] = []

## Applies damage from the closest attack in taking_damage_attacks
func finalize_attack() -> void:
	if taking_damage_attacks.size() == 0:
		return
	var attack_to_finalize: Attack = taking_damage_attacks.pop_front()
	
	if attack_to_finalize.type != EventBus.AttackType.None and \
			parameters.immunities.has(attack_to_finalize.type):
		system.display_text_near_unit(self, "Immunity")
		return
	
	var chance: float = randf()
	
	if attack_to_finalize.accuracy < chance:
		system.display_text_near_unit(self, "Miss!")
		EventBus.attack_missed.emit(self, attack_to_finalize)
		return
	
	if shielded_attacks.has(attack_to_finalize):
		system.display_text_near_unit(self, "Shield!")
		#EventBus.attack_shieled.emit(self, attack_to_finalize)
		return
	
	if attack_to_finalize.evadable:
		# recalculate random number to remove any numerical connection with accuracy
		chance = randf()
		
		if parameters.evasion > chance:
			EventBus.attack_evaded.emit(self, attack_to_finalize)
			system.display_text_near_unit(self, "Evaded!")
			return
	
	# apply effects if any are present
	if not attack_to_finalize.applying_effects.is_empty():
		for effect_name: String in attack_to_finalize.applying_effects:
			parameters.apply_effect(
				effect_name.to_lower(),
				attack_to_finalize.applying_effects[effect_name]
			)
	
	var damage_to_take: int = \
			attack_to_finalize.damages[spot] if attack_to_finalize.damages.has(spot) \
			else attack_to_finalize.default_damage
	take_damage(damage_to_take)
	
	# if untit is dead after taking damage, it was killed by this attack
	if parameters.dead:
		EventBus.unit_killed.emit(self, attack_to_finalize.attacker)


## Resolves an attack directed at this unit.
func resolve_attack(attack: Attack, delay: int = 0, finalize: bool = false) -> void:
	taking_damage_attacks.append(attack)
	if finalize:
		finalize_attack()
		return
	taking_damage_delays.append(delay)


## Called when [member EventBus.attack_reached] is emitted.
## Checks if unit has any planned damages to take and applies attack effects if so
func check_taking_damage(unit: Unit) -> void:
	if taking_damage_attacks.size() == 0:
		return
	if unit != taking_damage_attacks[0].attacker:
		return
	if taking_damage_delays.size() == 0:
		finalize_attack()
		return
	for i in range(taking_damage_delays.size()):
		taking_damage_delays[i] -= 1
	if taking_damage_delays[0] <= 0:
		taking_damage_delays.remove_at(0)
		finalize_attack()

#endregion

#region Delivering attacks


## Resets attack targets and emits a signal that the attack has finished.
func finish_attacking() -> void:
	reset_chosen_targets(self)
	set_next_attack()
	EventBus.attack_animation_finished.emit(self)


## Set to false when you need to skip next call of [method set_next_attack]
var attack_setting: bool = true

## Assigns next current_attack if possible
func set_next_attack() -> void:
	#print(unit_name)
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
## * The unit will only attack if [param attack] is one of its own attacks.[br]
## * [param attack] is removed from the attack queue.[br]
## * If [param attack] is [code]null[/code], the unit uses its closest available attack, if any.[br][br]
## If [param native_attack] is set to [code]false[/code], the attack is performed "out of nowhere,"
## meaning it is not removed from any unit's list and is not removed from the queue.
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
	
	animation_handle.play_attack_animation()
	system.combat_logic.book_damage(atk)

## Initiates an attack based on the chosen targets.
func start_attacking() -> void:
	if chosen_spots.is_empty():
		return
	defence_stance = false
	animation_handle.play_attack_animation()
	
	var attack: Attack = create_attack(current_attack, chosen_spots.duplicate())
	
	system.combat_logic.book_damage(attack)

# TODO: standardize spelling to 'defense'
## Returns if it was possible and thereby the unit has taken defense stance
func try_take_defense_stance() -> bool:
	if now_attacking():
		return false
	defence_stance = true
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
func heal(value: int) -> void:
	if value == 0:
		return
	if value < 0:
		take_damage(-value)
		return
	
	parameters.heal(value)
	animation_handle.play_heal_animation()
	system.display_text_near_unit(self, "+" + str(value), HEAL_COLOR)


const MIN_DAMAGE_COLOR = Color.WEB_MAROON
const MAX_DAMAGE_COLOR = Color.RED
const HEAL_COLOR = Color.LIME_GREEN


## Returnes interpolated color between [member MIN_DAMAGE_COLOR] and [member MAX_DAMAGE_COLOR]
## with the factor of damage dealt as a percentage of total helth
func damage_color(dmg: int) -> Color:
	var damage_percentage: float = float(dmg) / float(parameters.max_hp)
	damage_percentage = clampf(damage_percentage, 0.0, 1.0)
	return MIN_DAMAGE_COLOR.lerp(MAX_DAMAGE_COLOR, damage_percentage)


## Applies damage to the unit and triggers associated animations bypassing armor
func take_direct_damage(dmg: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> void:
	if dmg <= 0:
		return
	
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
func take_damage(dmg: int, message: String = "", text_color: Color = Color.TRANSPARENT) -> void:
	if dmg == 0:
		return
	if dmg < 0:
		heal(-dmg)
		return
	
	if defence_stance:
		dmg /= 2
	
	var damage_taken := parameters.take_damage(dmg)
	animation_handle.play_damage_animation(message)
	if message != "":
		message += ": "
	message += "-" + str(damage_taken)
	
	var color := text_color if \
			text_color != Color.TRANSPARENT else \
			damage_color(damage_taken)
	
	system.display_text_near_unit(
			self,
			message,
			color
	)

## Processes the unit's death.
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
