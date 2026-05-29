class_name UnitAttackData
extends Resource

## Display name for this action shown to players when selecting actions.
@export var attack_name: String = "Attack"
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

# ATTENTION
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

## Index of the attack animation to use. A value of [code]0[/code] selects
## the default animation. Currently only the default and one alternative 
## animation are supported, but an integer type is used to allow
## for future expansion with multiple alternatives.
@export var animation_index: int = 0

## Creates a new [UnitAttackData] instance with parameters from the provided dictionary.
## Missing entries use default values. [br][br]
##
## Supported dictionary fields with defaults:
## [codeblock]
## {
##     "attack_name" = "Attack",
##     "damage_multiplier" = 1.0,
##     "damage_override" = false,
##     "is_heal" = false,
##     "type" = GlobalDefs.AttackType.Physical,
##     "accuracy" = 0.95,
##     "targets_needed" = 1,
##     "initiative" = 0,
##     "evadable" = true,
##     "tags" = [],  # Array[StringName]
##     "target_validation" = "",  # Required field for all attacks
##     "additional_targets" = "",
##     "damage_policy" = "",
##     "applying_effects" = {},
##     "alternative_actions" = [],  # Array[UnitAttackData] or Array[Dictionary]
##     # Dictionaries in alternative_actions are recursively converted to UnitAttackData
## }
## [/codeblock]
static func from_dict(dict: Dictionary) -> UnitAttackData:
	var res := UnitAttackData.new()
	res.attack_name = dict.get("attack_name", "Attack")
	res.damage_multiplier = dict.get("damage_multiplier", 1.0)
	res.damage_override = dict.get("damage_override", false)
	res.is_heal = dict.get("is_heal", false)
	res.type = dict.get("type", GlobalDefs.AttackType.Physical)
	res.accuracy = dict.get("accuracy", 0.95)
	res.targets_needed = dict.get("targets_needed", 1)
	res.initiative = dict.get("initiative", 0)
	res.evadable = dict.get("evadable", true)
	res.tags.assign(dict.get("tags", []))
	res.target_validation = dict.get("target_validation", "")
	res.additional_targets = dict.get("additional_targets", "")
	res.damage_policy = dict.get("damage_policy", "")
	res.animation_index = dict.get("animation_index", 0)
	res.applying_effects.assign(dict.get("applying_effects", {}))
	var alt_actions: Array = dict.get("alternative_actions", [])
	for a: Variant in alt_actions:
		if a is Dictionary:
			res.alternative_actions.append(UnitAttackData.from_dict(a))
	return res
