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




@export var unit_name: String


@onready var animation_handle: UnitAnimationsHandle = get_node("AnimationHandle")
@onready var spot: UnitSpot = get_parent()

# Associated components and metadata
var parameters: UnitParameters
var party: Party
var system: CombatSystem


## Position in the party. Even numbers represent fron line, odd numbers - back line.
## Position is also index of this unit in the [member Party.units]
var party_position: int

# List of chosen targets for the unit.
var chosen_targets: Array[Unit]:
	get:
		var result: Array[Unit] = []
		for chosen_spot in chosen_spots:
			if chosen_spot.unit != null:
				result.append(chosen_spot.unit)
		return result
var chosen_spots: Array[UnitSpot] = []

## Attack that will be performed next
var current_attack: UnitAttack
## Attacks left to perform this round
var attacks_for_this_round: Array[UnitAttack]


## Alredy resolved attacks waiting to apply damage.
## Damage is applied when [member EventBus.attack_reached] is emitted.
## When [member EventBus.attack_finished] is emitted, all attacks in this list are immediately finalized
var taking_damage_attacks: Array[Attack] = []
## Every time [member EventBus.attack_reached] is emitted, all delays in this list areredused by 1.
## If the first element is 0, finalizes closest attack from [code]taking_damage_attacks[/code]
var taking_damage_delays: Array[int] = []

## Indicates if unit is in a defense stance
var defence_stance: bool = false

## If [code]true[/code], unit doesn't leave corpse after death. The object is comletely deleted
var summoned_unit: bool = false

## Clears chosen targets for the unit if it matches the provided unit.
## The argument here serves only to filter signal emits that could be triggered by other units
func reset_chosen_targets(_unit: Unit) -> void:
	if _unit == self:
		chosen_targets = []
		chosen_spots.clear()


## Sets attacks_for_this_round to its default value. Primarily used at the start of a new round.
func arrange_attacks() -> void:
	attacks_for_this_round = parameters.attacks.duplicate()


## Applies damages from all taking_damage_attacks
func finalize_all_attacks(_unit: Unit) -> void:
	while taking_damage_attacks.size() > 0:
		finalize_attack()
	taking_damage_delays.clear()


## Applies damage from the closest attack in taking_damage_attacks
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
	taking_damage_attacks.append(attack)
	if not attack.applying_effects.is_empty():
		for effect_name in attack.applying_effects:
			parameters.apply_effect(effect_name, attack.applying_effects[effect_name])
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


## Restores health to the unit and triggers associated animations.
func heal(value: int) -> void:
	if value == 0:
		return
	if value < 0:
		take_damage(-value)
		return
	
	parameters.heal(value)
	animation_handle.play_heal_animation()
	system.display_text_near_unit(self, "+" + str(value))

func take_direct_damage(dmg: int, message: String = "") -> void:
	if dmg <= 0:
		return
	
	var damage_taken = parameters.take_direct_damage(dmg)
	animation_handle.play_damage_animation(message)
	if message != "":
		message += ": "
	system.display_text_near_unit(self, message + "-" + str(damage_taken))

## Applies damage to the unit and triggers associated animations.
func take_damage(dmg: int, message: String = "") -> void:
	if dmg == 0:
		return
	if dmg < 0:
		heal(-dmg)
		return
	
	if defence_stance:
		dmg /= 2
	
	var damage_taken = parameters.take_damage(dmg)
	animation_handle.play_damage_animation(message)
	if message != "":
		message += ": "
	system.display_text_near_unit(self, message + "-" + str(damage_taken))



## Attempts to register a target for attack. Returns success or failure.
func give_target(spot: UnitSpot) -> bool:
	if current_attack == null:
		set_next_attack()
		if current_attack == null:
			return false
	if chosen_spots.size() >= current_attack.targets_needed:
		return false
	var is_target_valid: bool = current_attack.target_validation.call(self, spot)
	if not is_target_valid:
		return false
	chosen_spots.append(spot)
	if chosen_spots.size() == current_attack.targets_needed:
		start_attacking()
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
func start_attacking() -> void:
	defence_stance = false
	animation_handle.play_attack_animation()
	@warning_ignore("narrowing_conversion")
	var dmg: int = current_attack.damage_multiplier if current_attack.damage_override else \
			current_attack.damage_multiplier * parameters.base_damage
	
	var targets := chosen_spots.duplicate()
	if current_attack.find_additional_targets:
		targets = targets + current_attack.find_additional_targets.call(self, targets)
	#print_debug(targets.size())
	
	var attack: Attack = Attack.new(
		self, targets, dmg, current_attack.type, 
		current_attack.accuracy, parameters.attack_effect
	)
	if current_attack.damage_policy:
		attack.damage_policy = current_attack.damage_policy
	if not current_attack.applying_effects.is_empty():
		attack.applying_effects = current_attack.applying_effects
	system.combat_logic.book_damage(attack)

## Initializes unit variables and connects signals.
func initialize_variables() -> void:
	parameters = get_node("UnitParameters")
	party = get_parent().get_parent() as Party
	system = party.main_system
	if party == null:
		print_debug("Unable to find Party node!")
	parameters.initialize_variables()
	EventBus.turn_ended.connect(Callable(self, "reset_chosen_targets"))
	EventBus.round_started.connect(arrange_attacks)
	EventBus.attack_reached.connect(check_taking_damage)
	EventBus.attack_animation_finished.connect(finalize_all_attacks)


# Handles the unit being clicked on.
#func click() -> void:
	#system.clicked_unit(self)

func now_attacking() -> bool:
	if not chosen_targets.is_empty():
		return true
	if animation_handle.now_attacking:
		return true
	return false

func try_take_defense_stance() -> bool:
	if now_attacking():
		return false
	defence_stance = true
	system.display_text_near_unit(self, "Defending")
	return true

func try_waiting() -> bool:
	if now_attacking():
		return false
		
	attacks_for_this_round.append(current_attack)
	set_next_attack()
	
	system.display_text_near_unit(self, "Waiting...")
	return true

func visualize_death() -> void:
	if summoned_unit:
		queue_free()
		return
	
	visible = false

## Processes the unit's death (animation pending).
func die() -> void:
	EventBus.unit_died.emit(self)
	## TODO: Add death animation
	animation_handle.play_death_animation()
	
	party.units[party_position] = null
	spot.move_unit_to_graveyard()
