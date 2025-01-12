extends Node
class_name PlayerAPI

## This class serves as API for AI interactions with the combat system.
## When the combat system requests an input, it calles this class
## and any calles to the combat system done through this class.

signal turn_started(unit: Unit)

var combat_system: CombatSystem

## Party under this player's control
var party: Party

var disabled: bool = true

func choose_unit(spot: UnitSpot) -> void:
	if disabled:
		return
	
	combat_system.choose_unit(spot)


func use_defense_stance() -> void:
	if disabled:
		return
	
	if not combat_system.try_taking_defense_stance():
		print("Unable to defend!")

func use_waiting() -> void:
	if disabled:
		return
	
	if not combat_system.try_waiting():
		print("Unable to wait!")

func start_attack() -> void:
	if disabled:
		return
	
	combat_system.start_attacking_chosen_targets()
