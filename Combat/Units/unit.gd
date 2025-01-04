class_name Unit
extends Node2D

## Core class for all combat units.
## Handles interactions with the combat system and delegates tasks to helper classes
## (e.g., animations and parameters).

@export var unit_name: String
@onready var anim_handle: UnitAnimationsHandle = get_node("AnimationHandle")
@onready var external_highlight: AnimatedSprite2D = get_node("ExternalHighlight")

# Associated components and metadata
var parameters: UnitParameters
var party: Party
var system: CombatSystem
var party_position: int

# List of chosen targets for the unit.
var chosen_targets: Array[Unit] = []

# Attack that will be performed next
var current_attack: UnitAttack
var attacks_for_this_round: Array[UnitAttack]

## Highlights the unit externally.
func highlight_externally() -> void:
	external_highlight.visible = true

## Resets external highlight visibility.
func reset_highlight() -> void:
	external_highlight.visible = false

## Clears chosen targets for the unit if it matches the provided unit.
## The argument here serves only to filter signal emits that could be triggered by ither units
func reset_chosen_targets(_unit: Unit) -> void:
	if _unit == self:
		chosen_targets = []

func arrange_attacks() -> void:
	attacks_for_this_round = parameters.attacks.duplicate()
	#print(attacks_for_this_round)
	#set_next_attack()

var taking_damage_attacks: Array[Attack] = []
var taking_damage_delays: Array[int] = []

func finalize_all_attacks() -> void:
	while taking_damage_attacks.size() > 0:
		finalize_attack()
	taking_damage_delays.clear()

func finalize_attack() -> void:
	if taking_damage_attacks.size() == 0:
		return
	var chance: float = randf()
	var attack_to_finalize: Attack = taking_damage_attacks.pop_front()
	if attack_to_finalize.accuracy < chance:
		system.display_text_near_unit(self, "Miss!")
		return
	take_damage(attack_to_finalize.damage)

## Resolves an attack directed at this unit.
func resolve_attack(attack: Attack, delay: int = 0, finalize: bool = false) -> void:
	#if taking_damage_attacks != null:
		#print_debug("Attack overwritten!")
	#if taking_damage_attacks.has(attack):
		#return
	taking_damage_attacks.append(attack)
	if finalize:
		finalize_attack()
		return
	taking_damage_delays.append(delay)

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

## Applies damage to the unit and triggers associated animations.
func take_damage(dmg: int) -> void:
	parameters.take_damage(dmg)
	anim_handle.play_damage_animation()
	system.display_text_near_unit(self, "-" + str(dmg))

## Attempts to register a target for attack. Returns success or failure.
func give_target(unit: Unit) -> bool:
	if current_attack == null:
		set_next_attack()
		if current_attack == null:
			return false
	if chosen_targets.size() >= current_attack.targets_needed:
		return false
	var is_target_valid: bool = current_attack.target_validation.call(unit)
	if not is_target_valid:
		return false
	chosen_targets.append(unit)
	if chosen_targets.size() == current_attack.targets_needed:
		_start_attacking()
	return true

## Resets attack targets and emits a signal that the attack has finished.
func finish_attacking() -> void:
	reset_chosen_targets(self)
	EventBus.attack_animation_finished.emit(self)
	set_next_attack()

## Assigns next current_attack if possible
func set_next_attack() -> void:
	#print("===")
	current_attack = null
	if attacks_for_this_round.size() > 0:
		current_attack = attacks_for_this_round.pop_front()
		#print(current_attack.damage_multiplier)

## Initiates an attack based on the chosen targets.
func _start_attacking() -> void:
	anim_handle.play_attack_animation()
	var dmg: int = current_attack.damage_multiplier if current_attack.damage_override else \
			current_attack.damage_multiplier * parameters.base_damage
	var attack: Attack = Attack.new(
		self, chosen_targets, dmg, current_attack.type, 
		current_attack.accuracy, parameters.attack_effect
	)
	system.combat_logic.book_damage(attack)

## Initializes unit variables and connects signals.
func initialize_variables() -> void:
	parameters = get_node("UnitParameters")
	party = get_parent() as Party
	system = party.main_system
	if party == null:
		print_debug("Unable to find Party node!")
	parameters.initialize_variables()
	EventBus.turn_ended.connect(Callable(self, "reset_chosen_targets"))
	EventBus.round_started.connect(arrange_attacks)
	EventBus.attack_reached.connect(check_taking_damage)

## Handles the unit being clicked on.
func click() -> void:
	system.clicked_unit(self)

## Processes the unit's death (animation pending).
func die() -> void:
	EventBus.unit_died.emit(self)
	## TODO: Add death animation
	anim_handle.pause()
