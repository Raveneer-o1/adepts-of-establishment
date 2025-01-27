extends Node
class_name UnitAttack

## Represents attacks a unit can perform. 


## Unit, to which this object is attached
var unit: Unit
## Multiplier to [member Unit.base_damage]
@export var damage_multiplier := 1.0
## If [code]true[/code], damage_multiplier is used as damage and not as multiplier
@export var damage_override := false
## Damage type
@export var type: EventBus.AttackType
## Chance the attack won't be missed
@export var accuracy: float
## Number of units player will need to choose for a unit to perform this attack
@export var targets_needed: int = 1
## Determines the order of attacks
@export var initiative: int

#@export_dir var target_validation_path: String
#@export_dir var additional_targets_path: String
#@export_dir var damage_policy_path: String

## Function with signature [codeblock](attacker: Unit, target: UnitSpot) -> bool[/codeblock]
## Returns whether [code]target[/code] is a valid targert for the attack
@export var target_validation: BaseValidation

## Function with a signature [codeblock](attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit][/codeblock]
## Returns list of auto-determined targets
## Note: if combined with damage_policy, pay attention to the order of added units
@export var additional_targets: BaseAdditionalTargets

## Function with a signature [codeblock](attack: Attack, index: int) -> void [/codeblock]
## If present, overrides [method Attack.resolve] and applies to all targets using their indexes
@export var damage_policy: BasePolicy


## Dictionary containing elements in the format: <effect_name: String, params: Variant>[br]
## This element is passed to the [member Attack.applying_effects]
@export var applying_effects : Dictionary

## If set, attack will use this effect instead if unit's one
## @experimental: currently not implemented
@export var effect_override : Resource

func initialize(u: Unit) -> void:
	if target_validation == null:
		print_debug("Target validation is empty! Unit: %s" % u.unit_name)
		u.queue_free()
	unit = u
