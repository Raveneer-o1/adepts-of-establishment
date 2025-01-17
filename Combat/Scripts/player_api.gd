extends Node
class_name PlayerAPI

## This class serves as API for AI interactions with the combat system.
## When the combat system requests an input, it calles this class
## and any calles to the combat system done through this class.

## Delay between two consecutive actions. This makes combat flow more natural
## and by delaying signal emition allows the stack to be reset if the battle is played between two AI
const ACTION_DELAY = 0.1

signal _turn_started(unit: Unit)

var combat_system: CombatSystem

## Party under this player's control
var party: Party

var disabled: bool = true

var awaiting_action: bool = false

func start_turn() -> void:
	if awaiting_action:
		return
	get_tree().create_timer(ACTION_DELAY).timeout.connect(func() -> void: awaiting_action = true)


func choose_unit(spot: UnitSpot) -> void:
	if disabled:
		return
	
	awaiting_action = false
	combat_system.choose_unit(spot)


func use_defense_stance() -> void:
	if disabled:
		return
	
	awaiting_action = false
	if not combat_system.try_taking_defense_stance():
		print("Unable to defend!")

func use_waiting() -> void:
	if disabled:
		return
	
	awaiting_action = false
	if not combat_system.try_waiting():
		print("Unable to wait!")

func start_attack() -> void:
	if disabled:
		return
	
	awaiting_action = false
	combat_system.start_attacking_chosen_targets()

func  _process(delta: float) -> void:
	if not awaiting_action:
		return
	_turn_started.emit(combat_system.current_unit)
