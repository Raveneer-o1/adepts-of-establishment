class_name Unit extends Node2D
	
var parameters: UnitParameters
@onready var anim_handle: UnitAnimationsHandle = get_node("AnimationHandle")
var party: Party
var system: CombatSystem

var chosen_targets: Array[Unit] = []

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

func start_attacking() -> void:
	anim_handle.play_attack_animation()
	for i in range(chosen_targets.size()):
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
				self,
				chosen_targets[i],
				dmg,
				u_attack.type,
				randf() > u_attack.accuracy
				)
		system.book_damage(attack)

func initialize_variables() -> void:
	parameters = get_node("UnitParameters")
	party = get_parent().get_parent() as Party
	system = party.main_system
	if party == null:
		print_debug("Unable to find Party node!")
	EventBus.turn_ended.connect(Callable(self, "reset_chosen_targets"))

#func _ready() -> void:
	#initialize_variables()
	##print("hi")

func click() -> void:
	system.clicked_unit(self)
