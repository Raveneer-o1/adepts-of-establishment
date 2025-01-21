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
@export var targets_needed: int
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
#var damage_policy: Callable


## Dictionary containing elements in the format: <effect_name: String, params: Variant>[br]
## This element is passed to the [member Attack.applying_effects]
var applying_effects : Dictionary

func initialize(u: Unit) -> void:
	unit = u
	
	#var loaded := load(target_validation_path)
	#target_validation = \
		#load(target_validation_path) as BaseValidation if FileAccess.file_exists(target_validation_path) \
		#else null
	#
	#additional_targets = \
		#load(additional_targets_path) if FileAccess.file_exists(additional_targets_path) \
		#else null
	#
	#damage_policy = \
		#load(damage_policy_path) if FileAccess.file_exists(damage_policy_path) \
		#else null

#func _init(_unit: Unit, dmg_mult: float, dmg_ov: bool,
		#valid: Callable, ty: EventBus.AttackType, acc: float,
		#targets: int, _initiative: int) -> void:
	#unit = _unit
	#damage_multiplier = dmg_mult
	#damage_override = dmg_ov
	#target_validation_override = valid_ov
	#target_validation = valid
	#type = ty
	#accuracy = acc
	#targets_needed = targets
	#initiative = _initiative
