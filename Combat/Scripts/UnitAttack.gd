class_name UnitAttack

## Represents attacks a unit can perform. 

## Unit, to which this object is attached
var unit: Unit
## Multiplier to [member Unit.base_damage]
var damage_multiplier := 1.0
## If [code]true[/code], damage_multiplier is used as damage and not as multiplier
var damage_override := false
## Damage type
var type: EventBus.AttackType
## Chance the attack won't be missed
var accuracy: float
## Number of units player will need to choose for a unit to perform this attack
var targets_needed: int
## Determines the order of attacks
var initiative: int
## Function with signature [codeblock](attacker: Unit, target: UnitSpot) -> bool[/codeblock]
## Returns whether [code]target[/code] is a valid targert for the attack
var target_validation : Callable

## Function with a signature [codeblock](attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit][/codeblock]
## Returns list of auto-determined targets
## Note: if combined with damage_policy, pay attention to the order of added units
var find_additional_targets: Callable

## Function with a signature [codeblock](attack: Attack, index: int) -> void [/codeblock]
## If present, overrides [method Attack.resolve] and applies to all targets using their indexes
var damage_policy: Callable


# Dictionary with elements [codeblock] <effect_name: String, params: Variant> [/codeblock]
# Here [code]effect_name[/code] is the name of a scene that the game looks for in the folder
# [kbd]res://Combat/Effects/AppliedEffects/Scenes/[/kbd].[br]
# And [code]params[/code] is parameters that the effect will get.
# [code]params[/code] is parsed within the effect class.

## Dictionary containing elements in the format: <effect_name: String, params: Variant>[br]
## This element is passed to the [member Attack.applying_effects]
var applying_effects : Dictionary

func _init(_unit: Unit, dmg_mult: float, dmg_ov: bool,
		valid: Callable, ty: EventBus.AttackType, acc: float,
		targets: int, _initiative: int) -> void:
	unit = _unit
	damage_multiplier = dmg_mult
	damage_override = dmg_ov
	#target_validation_override = valid_ov
	target_validation = valid
	type = ty
	accuracy = acc
	targets_needed = targets
	initiative = _initiative
