class_name UnitAttackData
extends Resource

## Multiplier to [member Unit.base_damage]. If [member damage_override] is set to 
## [code]true[/code], this value is cast into int and used as damage instead. [br]
## Similar to [member BaseParameters.base_damage], this can be set to 0 without any
## issues.
@export var damage_multiplier := 1.0
## If [code]true[/code], damage_multiplier is used as damage and not as multiplier
@export var damage_override := false
## if [code]true[/code], heals the target instead of applying damage
@export var is_heal: bool = false
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

## This list of tags is copied and appended to the [Attack] object when created.
@export var tags: Array[StringName]

## [color=red]This field is required for each attack![/color][br]
## Determines whether any particular target is valid for the attack.[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export_file_path("*.tres") var target_validation: String

## Returns list of auto-determined targets[br]
## If combined with [member damage_policy], pay attention to the order of added units[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export_file_path("*.tres") var additional_targets: String

## If present, overrides [method Attack.resolve] and applies to all targets using their indexes[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export_file_path("*.tres") var damage_policy: String

## This element is passed to the [member Attack.applying_effects]
@export var applying_effects : Dictionary[String, Variant]

@export var alternative_actions: Array[UnitAttackData]
