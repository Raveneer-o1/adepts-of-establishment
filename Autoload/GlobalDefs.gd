extends Node

const units_database := preload("res://Databases/unit_database.gd")

## Type of the player
enum ControllerType{
	Human,
	BasicAI,
	StandardAI,
}

## Unit type is used to determine default behavior in certain situations
enum UnitType{
	## When a melee unit assumes a defense stance, it automatically [i]shields[/i] (see [Unit])
	Melee,
	## Unit automatically adds [code]&"shot"[/code] tag to its attacks
	Archer,
	## No special effects
	Mage,
	## Support units can be [i]shielded[/i] by others even if that unit is not [i]shielding[/i]
	Support,
	
	Undefined,
}

## Defines the type of attack or damage, which determines synergies, 
## immunities, and other interactions.
enum AttackType {
	## Standard physical attacks used by most units
	Physical,
	## Elemental magic attacks used by spellcasting units
	Elemental,
	## Primarily used for debuffs and mental effects
	Mind,
	## Primarily used for healing and beneficial effects
	Life,
	## Bypasses all shields and immunities. [br]
	## [color=lightgreen]Note: [method Unit.finalize_attack] explicitly checks for None type 
	## when verifying immunities, but other systems rely on proper usage - the game cannot
	## automatically distinguish between attacks that should interact with game mechanics
	## and those that should not based on attack type.[/color]
	None
}

# List of all available factions.
# Note: this should include all factions, not only playable ones
enum Faction {
	Undefined,
	
	## Playable faction (humans)
	Empire,
	## Playable faction (undead)
	Necropolis,
	## Playable faction (humans)
	Church,
	## Playable faction (demons)
	DarkForces,
	
	Neutral,
	Pirates,
	Bandits,
	Greenskin,
	
	## For player-defined factions and factions defined in add-ons
	Custom,
}

## Returns the file path to the combat controller scene based on controller type
func get_combat_controller(type: GlobalDefs.ControllerType) -> String:
	match type:
		GlobalDefs.ControllerType.Human:
			return "res://Combat/Scenes/player_controller.tscn"
		GlobalDefs.ControllerType.BasicAI:
			return "res://Combat/Scenes/basic_combat_ai.tscn"
		GlobalDefs.ControllerType.StandardAI:
			return "res://Combat/Scenes/standard_combat_ai.tscn"
	push_error("Unknown Controller type!")
	return ""

## Returns the file path to the faction controller scene based on controller type
func get_faction_controller(type: GlobalDefs.ControllerType) -> String:
	match type:
		GlobalDefs.ControllerType.Human:
			return "res://Map/Scenes/Controllers/player_controller.tscn"
		GlobalDefs.ControllerType.BasicAI:
			return "res://Map/Scenes/Controllers/dummy_controller.tscn"
		GlobalDefs.ControllerType.StandardAI:
			return "res://Map/Scenes/Controllers/basic_ai_controller.tscn"
	push_error("Unknown Controller type!")
	return ""

var rolls_statistic: Dictionary[Party, int]

func _increase_roll_statistics(party: Party) -> void:
	if party in rolls_statistic:
		rolls_statistic[party] += 1
	else:
		rolls_statistic[party] = 1

## Sets the testing mode to the specified [param value].
## In this mode, all random functions become deterministic.
## See [enum TestingMode] for details.
func set_testing_mode(value: TestingMode) -> void:
	if not OS.is_debug_build():
		__testing_mode__ = TestingMode.Off
		return
	__testing_mode__ = value

var __testing_mode__: TestingMode = TestingMode.Off

enum TestingMode{
	Off,
	## Random functions always return the result beneficial to the left party
	## or [code]true[/code] if the [b]benefits[/b] parameter not specified.
	Left,
	## Random functions always return the result beneficial to the right party
	## or [code]true[/code] if the [b]benefits[/b] parameter not specified.
	Right,
}

func _ready() -> void:
	if not OS.is_debug_build(): __testing_mode__ = TestingMode.Off

## Returns a random integer between [param average] - [param lower_deviation] and
## [param average] + [param upper_deviation], inclusive.
## If [param lower_deviation] is omitted, it defaults to the negation of
## [param upper_deviation].[br][br]
## This function is recommended over the built‑in one because it respects
## testing mode: when testing mode is enabled, it returns exactly [param average].
func rand_range(
	average: int,
	upper_deviation: int,
	lower_deviation: int = -upper_deviation,
) -> int:
	if __testing_mode__ == TestingMode.Off:
		return randi_range(average - lower_deviation, average + upper_deviation)
	return average

## Returns [code]true[/code] or [code]false[/code] based on the specified
## probability [param chance] and records statistics. [br][br]
## [param benefits]: The party that benefits from a positive outcome ([b]true[/b] result).
## Leave null for neutral rolls where no statistics should be recorded. [br][br]
## By default, chance values outside the [code](0.0, 1.0)[/code]
## range are not recorded in statistics.
## Set [param force_statistic_recording] to [b]true[/b] to record the
## outcome regardless of chance value.
func rand_roll(
	chance: float,
	benefits: Party = null,
	force_statistic_recording: bool = false,
) -> bool:
	match __testing_mode__:
		TestingMode.Right: return false if benefits and benefits.is_left else true
		TestingMode.Left: return false if benefits and !benefits.is_left else true
	
	if is_zero_approx(chance):
		if force_statistic_recording and benefits != null:
			_increase_roll_statistics(benefits.other_party)
		return false
	if chance < 0.0:
		push_error("Negative probablity!")
		if force_statistic_recording and benefits != null:
			_increase_roll_statistics(benefits.other_party)
		return false
	if chance >= 1.0: 
		if force_statistic_recording and benefits != null:
			_increase_roll_statistics(benefits)
		return true
	
	var did_pass := chance > randf()
	if benefits:
		var party := benefits if did_pass else benefits.other_party
		_increase_roll_statistics(party)
	return did_pass
