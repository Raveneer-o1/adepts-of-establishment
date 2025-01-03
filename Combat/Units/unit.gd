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
		chosen_targets.clear()

## Resolves an attack directed at this unit.
func resolve_attack(attack: Attack) -> void:
	if attack.whiff:
		system.display_text_near_unit(self, "Miss!")
		return
	take_damage(attack.damage)

## Applies damage to the unit and triggers associated animations.
func take_damage(dmg: int) -> void:
	parameters.take_damage(dmg)
	anim_handle.play_damage_animation()
	system.display_text_near_unit(self, "-" + str(dmg))

## Attempts to register a target for attack. Returns success or failure.
func give_target(unit: Unit) -> bool:
	if chosen_targets.size() >= parameters.targets_need:
		return false
	var is_target_valid: bool = parameters.get_last_validation(chosen_targets.size()).call(unit)
	if not is_target_valid:
		return false
	chosen_targets.append(unit)
	if chosen_targets.size() == parameters.targets_need:
		_start_attacking()
	return true

## Resets attack targets and emits a signal that the attack has finished.
func finish_attacking() -> void:
	reset_chosen_targets(self)
	EventBus.attack_animation_finished.emit(self)

## Initiates an attack based on the chosen targets.
func _start_attacking() -> void:
	anim_handle.play_attack_animation()
	for i in range(chosen_targets.size()):
		var u_attack: UnitAttack = parameters.attacks[min(i, parameters.attacks.size() - 1)]
		var dmg: int = u_attack.damage_multiplier if u_attack.damage_override else \
				u_attack.damage_multiplier * parameters.base_damage
		var attack: Attack = Attack.new(
			self, chosen_targets[i], dmg, u_attack.type, 
			randf() > u_attack.accuracy, parameters.attack_effect
		)
		system.combat_logic.book_damage(attack)

## Initializes unit variables and connects signals.
func initialize_variables() -> void:
	parameters = get_node("UnitParameters")
	party = get_parent() as Party
	system = party.main_system
	if party == null:
		print_debug("Unable to find Party node!")
	EventBus.turn_ended.connect(Callable(self, "reset_chosen_targets"))
	parameters.initialize_variables()

## Handles the unit being clicked on.
func click() -> void:
	system.clicked_unit(self)

## Processes the unit's death (animation pending).
func die() -> void:
	EventBus.unit_died.emit(self)
	## TODO: Add death animation
	anim_handle.pause()
