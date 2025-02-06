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

## If [code]false[/code], target units can't evade this attack
## during resolution but attack can still be missed.
@export var evadable: bool = true

## [color=red]This field is required for each attack![/color][br]
## Returns whether [code]target[/code] is a valid targert for the attack.[br]
## NOTE: you need to attach a resource, not a script file
@export var target_validation: BaseValidation

## Returns list of auto-determined targets[br]
## NOTE: if combined with [member damage_policy], pay attention to the order of added units[br]
## NOTE: you need to attach a resource, not a script file
@export var additional_targets: BaseAdditionalTargets

## If present, overrides [method Attack.resolve] and applies to all targets using their indexes[br]
## NOTE: you need to attach a resource, not a script file
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
		queue_free()
	unit = u

func can_be_performed() -> bool:
	if unit == null:
		return false
	if unit.parameters.dead:
		return false
	if unit.current_attack == self:
		return true
	return unit.attacks_for_this_round.has(self)
