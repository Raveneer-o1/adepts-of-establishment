extends Node
class_name UnitAttack

## Represents attacks a unit can perform. 
##
## This node is the base for all [i]attacks[/i]. An [i]attack[/i] is an action a [Unit] can perform.
## Units act when and only when they have an attack to perform. Even if an actual attack 
## is not performed, units can not act until its their turn. And since turns are determined by
## attacks, the concept of a [UnitAttack] represents an opportunity to act. [br] [br]
##
## [UnitAttack]s are attached directly to the [UnitParameters] node. No additional setup
## is required: [UnitParameters] scans all child nodes and uses all [UnitAttack]s it can find.
## [br] [br]
##
## [color=yellow]Note:[/color] this class is not intended to be overriden. Use composition instead.[br]
## [b]See also:[/b] [CombatSystem], [Unit]

## Unit, to which this object is attached
var unit: Unit
## Multiplier to [member Unit.base_damage]. If [member damage_override] is set to 
## [code]true[/code], this value is cast into int and used as damage instead.
@export var damage_multiplier := 1.0
## If [code]true[/code], damage_multiplier is used as damage and not as multiplier
@export var damage_override := false
## Damage type
@export var type: GlobalDefs.AttackType
## Chance the attack won't be missed
@export var accuracy: float = 0.95
## Number of units player will need to choose for a unit to perform this attack
@export var targets_needed: int = 1
## Determines the order of attacks
@export var initiative: int

## If [code]false[/code], target units can't evade this attack
## during resolution but attack can still be missed.
@export var evadable: bool = true

## [color=red]This field is required for each attack![/color][br]
## Determines whether any particular target is valid for the attack.[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export var target_validation: BaseValidation

## Returns list of auto-determined targets[br]
## If combined with [member damage_policy], pay attention to the order of added units[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export var additional_targets: BaseAdditionalTargets

## If present, overrides [method Attack.resolve] and applies to all targets using their indexes[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export var damage_policy: BasePolicy


## Dictionary containing elements in the format: <effect_name: String, params: Variant>[br]
## This element is passed to the [member Attack.applying_effects]
@export var applying_effects : Dictionary

## If set, attack will use this effect instead if unit's one
## @experimental: currently not implemented
@export var effect_override : Resource

## This method is called by [UnitParameters] at the start of the combat. [br]
## Note: Currently not implemented, but [UnitParameters] will also be responsible 
## for calling it for any attacks added during the battle.
## You should not attempt to initialize the attack manually.
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
