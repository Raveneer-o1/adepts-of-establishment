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
## [UnitAttack] node can have any number of other [UnitAttack] nodes as children.
## The main [UnitAttack] and all its children form a single action set: 
## the player can choose any one of these actions to perform as an attack.
## Typically, these alternative actions aren't conventional attacks but special abilities,
## still implemented as [UnitAttack] class instances with custom [member damage_policy]
## for the desired behavior (see the [i]Vampire Lord[/i] unit as an example). [br][br]
##
## [color=yellow]Note:[/color] this class is not intended to be overriden.
## Use composition instead.[br]
## [b]See also:[/b] [CombatSystem], [Unit]

## Unit, to which this object is attached
var unit: Unit
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
@export var target_validation: BaseValidation

## Returns list of auto-determined targets[br]
## If combined with [member damage_policy], pay attention to the order of added units[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export var additional_targets: BaseAdditionalTargets

## If present, overrides [method Attack.resolve] and applies to all targets using their indexes[br]
## [color=lightgreen]Note: you need to attach a resource, not a script file[/color]
@export var damage_policy: BasePolicy

## This element is passed to the [member Attack.applying_effects]
@export var applying_effects : Dictionary[String, Variant]

## If set, attack will use this effect instead if unit's one
## @experimental: currently not implemented
@export var effect_override : Resource

## If not empty, this text is displayed to the player as the unit's ability description.
## Use this to explain unique attack policies, target selection rules,
## and automatic additional targets.
@export_multiline var description: String = ""

## Returns a human-friendly accuracy representation rather than raw probabilities.
## The idea is to never show actual percentages to the player and avoid behind-the-scenes
## number manipulation (as it's usually done to improve player perception). [br]
## The formula essentially gives X for the phrase [b]"unit will miss 1 in X attacks"[/b]. [br]
## Returns [code]NAN[/code] if accuracy is 0.0 (guaranteed miss) [br]
## Returns [code]INF[/code] if accuracy is 1.0 (guaranteed hit) [br] [br]
## [center][i]Conversion examples: [br]
## 0.25 (25%) → 1.333333 [br]
## 0.5 (50%) → 2.0 [br]
## 0.75 (50%) → 4.0 [br]
## 0.85 (85%) → 7.0 [br]
## 0.9 (90%) → 10.0 [br]
## 0.95 (95%) → 20.0 [br]
## 0.975 (97.5%) → 40.0 [br]
## 0.99 (99%) → 100.0 [br]
## 0.995 (99.5%) → 199.999... [/i] [/center]
var accuracy_representation: float:
	get:
		if is_zero_approx(accuracy): return NAN
		var chance_to_miss: float = 1.0 - accuracy
		if is_zero_approx(chance_to_miss): return INF
		return 1.0 / chance_to_miss

func _read_data(data: UnitAttackData) -> void:
	damage_multiplier = data.damage_multiplier
	damage_override = data.damage_override
	is_heal = data.is_heal
	type = data.type
	accuracy = data.accuracy
	targets_needed = data.targets_needed
	initiative = data.initiative
	evadable = data.evadable
	tags = data.tags
	target_validation = load(data.target_validation)
	additional_targets = load(data.additional_targets) if data.additional_targets else null
	damage_policy = load(data.damage_policy) if data.damage_policy else null
	applying_effects = data.applying_effects
	for c: UnitAttack in get_children():
		c.free()
	for alt in data.alternative_actions:
		var alternative := UnitAttack.new()
		alternative.initialize(unit, alt)

func _initialize_alternative() -> void:
	for c: UnitAttack in get_children():
		c.initialize(unit, null)

## This method is called by [UnitParameters] at the start of the combat. [br]
## Note: Currently not implemented, but [UnitParameters] will also be responsible 
## for calling it for any attacks added during the battle.
## You should not attempt to initialize the attack manually.
func initialize(u: Unit, data: UnitAttackData) -> void:
	unit = u
	if data: _read_data(data)
	else: _initialize_alternative()
	
	if target_validation == null:
		push_error("Target validation is empty! Unit: %s" % u.unit_name)
		queue_free()

func can_be_performed() -> bool:
	if unit == null:
		return false
	if unit.parameters.dead:
		return false
	if unit.current_attack == self:
		return true
	return unit.attacks_for_this_round.has(self)

## Swaps this attack with [member Unit.current_attack]. [br][br]
##
## The unit's [member attacks] list doesn't account for initiative and random shuffling, so the
## performed attack may differ from the one in [member CombatLogic.attacks_queue].
## Call this method before constructing an attack to avoid that.
func make_current() -> void:
	if not unit: return
	if unit.parameters.dead: return
	if unit.current_attack == self: return
	var prev_atk: UnitAttack = unit.current_attack
	var pos := unit.attacks_for_this_round.find(self)
	if pos < 0: return
	unit.attacks_for_this_round[pos] = prev_atk
	unit.current_attack = self
