class_name Unit extends Node2D

## Core class of all units in combat. Handles high-level interactions with the combat system 
## and sends requests to helper classes (UnitAnimationsHandle, UnitParameters)

@export var unit_name: String
@onready var anim_handle: UnitAnimationsHandle = get_node("AnimationHandle")
@onready var external_highlight := get_node("ExternalHighlight") as AnimatedSprite2D

var parameters: UnitParameters
var party: Party
var system: CombatSystem

var party_position: int

var chosen_targets: Array[Unit] = []


func highlight_externally() -> void:
	external_highlight.visible = true

func reset_highlight() -> void:
	external_highlight.visible = false

func reset_chosen_targets(_unit: Unit) -> void:
	if _unit == self:
		chosen_targets.clear()

func resolve_attack(attack: Attack) -> void:
	if attack.whiff:
		system.display_text_near_unit(self, "Miss!")
		return
	take_damage(attack.damage)

func take_damage(dmg: int) -> void:
	parameters.take_damage(dmg)
	anim_handle.play_damage_animation()
	system.display_text_near_unit(self, "-" + str(dmg))

## Tries to initialize target for attack. Returns weather or not in was succesfull
func give_target(unit: Unit) -> bool:
	var targets_chosen := chosen_targets.size()
	
	if targets_chosen >= parameters.targets_need:
		return false
		
	var is_target_valid: bool = parameters.get_last_validation(targets_chosen).call(unit)
	if not is_target_valid:
		return false
	chosen_targets.append(unit)
	
	if chosen_targets.size() == parameters.targets_need:
		start_attacking()
	return true

func finish_attacking() -> void:
	reset_chosen_targets(self)
	EventBus.attack_animation_finished.emit(self)

## Specifies parameters of an attack that's booked. That includes determining if an attack is missed
func start_attacking() -> void:
	anim_handle.play_attack_animation()
	
	for i in range(chosen_targets.size()):
		
		# If there's not enough attacks if the array, use the last one
		var u_attack : UnitAttack
		if parameters.attacks.size() > i:
			u_attack = parameters.attacks[i]
		else :
			u_attack = parameters.attacks[parameters.attacks.size() - 1]
		
		var dmg: int
		if u_attack.damage_override:
			dmg = u_attack.damage_multiplier
		else:
			dmg = u_attack.damage_multiplier * parameters.base_damage
		
		var attack : Attack = Attack.new(
				self, # attacker
				chosen_targets[i], #target
				dmg, #damage
				u_attack.type, #attack type
				randf() > u_attack.accuracy # if attack is missed
				)
		
		system.combat_logic.book_damage(attack)

func initialize_variables() -> void:
	parameters = get_node("UnitParameters")
	party = get_parent().get_parent() as Party
	system = party.main_system
	if party == null:
		print_debug("Unable to find Party node!")
	EventBus.turn_ended.connect(Callable(self, "reset_chosen_targets"))
	parameters.initialize_variables()

func click() -> void:
	system.clicked_unit(self)

func die() -> void:
	EventBus.unit_died.emit(self)
	queue_free()
