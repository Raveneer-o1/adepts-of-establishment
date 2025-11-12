class_name Attack
extends RefCounted

## Attack that is being performed
##
## This class manages attacks in the proccess of being performed.
## Each [Attack] goes through a series of stages: [br]
## 1. [b]Target Validation[/b]: The player/AI selects valid targets based on attack rules
## (see [member UnitAttack.target_validation], class [BaseValidation]).[br]
## 2. [b]Attack Booking[/b]: An [Attack] instance is created and queued for resolution. This emits
## [signal EventBus.attack_booked].[br]
## 3. [b]Effect Application[/b]: Effects connected to [signal EventBus.attack_booked]
## can modify the booked attack.[br]
## 4. [b]Resolution[/b]: When the animation reaches its first active frame
## (set via [member UnitAnimationsHandle.frames_to_emit]), all attacks are resolved.[br]
## 5. [b]Finalization[/b]: In some cases, it might be necessary to delay the visual
## representation of the attack results (e.g., when there are two active frames, you
## might want to delay the second damage number until the second hit actually connects).
## In this case, the unit will store the parameters (see [member Unit.parameter_snapshots])
## needed to represent the intermidiate states but not update the visuals until
## [signal EventBus.attack_reached] is emitted again.[br]
## [color=lightyellow]Note: actual parameters are updated as soon as the attack is resolved,
## the delay if purely visual.[/color][br]
## 6. [b]Cleanup[/b]: The next attack from the [i]action queue[/i] is popped and moved to
## [member CombatLogic.current_attack].[br][br]
##
## [b]See also:[/b] [CombatSystem], [UnitAttack], [Unit]

var damages: Dictionary[UnitSpotReference, int] = {}
var target_references: Array[UnitSpotReference] = []

# if target can't be found in damages dictionary, this value will be used as damage
var default_damage: int

var redirected: bool = false

var accuracy: float
var type: GlobalDefs.AttackType
var attacker: Unit
var target_spots: Array[UnitSpot]:
	get:
		var result: Array[UnitSpot] = []
		for key: UnitSpotReference in target_references:
			result.append(key.spot)
		return result
var targets: Array[Unit]:
	get:
		var result : Array[Unit] = []
		for ref: UnitSpotReference in target_references:
			if ref.spot and ref.spot.unit:
				result.append(ref.spot.unit)
		return result
var effect: Resource

## Number of targets selected by the player. Used for animation synchronization.[br]
## The first [b]targets_chosen[/b] damage numbers will display as [signal EventBus.attack_reached]
## signals are emitted, while all other effects are applied simultaneously with the last finalization.
var targets_chosen: int = 1

var evadable: bool

## [code]key[/code]: The name of a scene located in the folder 
## [kbd]res://Combat/Effects/AppliedEffects/Scenes/[/kbd]. Case insensitive.
## This is used by the game to dynamically load the effect.[br]
## [code]value[/code]: A set of parameters passed to the effect. Parsed and handled
## within the respective effect class.
var applying_effects: Dictionary[String, Variant]

## If present, overrides [method Attack.resolve] and applies to all targets. [br]
## Unlike [member validation] and [member additional_targets], this field is copied from
## the original [UnitAttack] object and can be dynamically redefined. [br]
## [method BasePolicy.apply_policy] is a function with the signature:
## [codeblock]
## # if finalize is true, visuals will be displayed immediately
## func apply_policy(attack: Attack, finalize: bool) -> void
## [/codeblock]
var damage_policy: BasePolicy

## Reference to the original [UnitAttack] object
var unit_attack: UnitAttack

## Unlike [UnitAttack], [Attack] objects do not perform validation by default.
## This field is available for cases where validation is needed
## (e.g., redirecting attacks to valid targets)
var validation: BaseValidation:
	get: return unit_attack.target_validation

var additional_targets: BaseAdditionalTargets:
	get: return unit_attack.additional_targets

## Tags provide a flexible way to assign and check attack properties. Tags are not 
## automatically processed by the system, but they offer a convenient method for tracking
## various attack attributes. For example, see the [i]shielding[/i] mechanic and the 
## [code]&"shot"[/code] tag (documentation in the [Unit] class).
var tags: Array[StringName] = []

var is_heal: bool

var applied_damage: int = 0

## Calles [method Unit.resolve_attack] on each of its targets
func resolve(finalize: bool = false) -> void:
	if damage_policy:
		damage_policy.apply_policy(self, finalize)
	else:
		standard_resolution(finalize)
	EventBus.attack_resolved.emit(self)
	#EventBus.attack_resolved_trigger.emit(self)

func standard_resolution(finalize: bool = false) -> void:
	var i := 1
	for target in target_references:
		if not ( \
			target.spot and \
			target.spot.unit and \
			not target.spot.unit.parameters.dead \
		): continue
		var damage_to_take: int = damages[target] if damages.has(target) else default_damage
		target.spot.unit.resolve_attack(self, damage_to_take, i, finalize)
		if i < targets_chosen:
			i += 1

func set_parameters(attack: UnitAttack) -> void:
	damage_policy = attack.damage_policy
	applying_effects = attack.applying_effects.duplicate()

func redirect_to(target_ref: UnitSpotReference, to:UnitSpot) -> void:
	var index: int = target_references.find(target_ref)
	if index < 0: return
	
	var new_ref := UnitSpotReference.new(to)
	
	target_references[index] = new_ref
	if target_ref in damages:
		var damage: int = damages[target_ref]
		damages.erase(target_ref)
		damages[new_ref] = damage
	redirected = true

func redirect_all(target: UnitSpot, to: UnitSpot) -> void:
	for t:UnitSpotReference in target_references:
		if t.spot == target: redirect_to(t, to)

## Redirects the attack as if given spot was the original target.
## This allows to correctly redirect more complex attacks (e.g. with splash effects).
func deep_redirect(to: UnitSpot) -> void:
	redirected = true
	target_references.clear()
	for i in range(targets_chosen):
		target_references.append( UnitSpotReference.new(to) )
	#damages.clear()
	#targets_chosen = target_references.size()
	if additional_targets:
		var additional := additional_targets.find_additional_targets(attacker, target_spots)
		for a in additional:
			target_references.append( UnitSpotReference.new(a) )

## Returns the first reference to the [param target] in [member damages]
func find_all_references(target: UnitSpot) -> Array[UnitSpotReference]:
	var result: Array[UnitSpotReference] = []
	for t: UnitSpotReference in target_references:
		if t.spot == target: result.append(t)
	return result

## Returns the first reference to the [param target] in [member target_references].
## Returns null if there is none
func find_reference(target: UnitSpot) -> UnitSpotReference:
	for t: UnitSpotReference in target_references:
		if t.spot == target: return t
	return null

func is_primary_target(target: UnitSpot) -> bool:
	var pos := target_spots.find(target)
	return pos >= 0 and pos < targets_chosen

func __init_via_Attack(attack: Attack) -> void:
	type = attack.type
	attacker = attack.attacker
	accuracy = attack.accuracy
	evadable = attack.evadable
	effect = attack.effect
	validation = attack.validation
	targets_chosen = attack.targets_chosen

func __init_via_UnitAttack(_unit_attack: UnitAttack, eff: Resource) -> void:
	type = _unit_attack.type
	attacker = _unit_attack.unit
	accuracy = _unit_attack.accuracy
	evadable = _unit_attack.evadable
	unit_attack = _unit_attack
	targets_chosen = _unit_attack.targets_needed
	is_heal = _unit_attack.is_heal
	
	if _unit_attack.effect_override:
		effect = _unit_attack.effect_override
	else:
		effect = eff

func _init(_param: Variant, _spots: Array[UnitSpot],
		dmg: int, eff: Resource = null) -> void:
	if _param is UnitAttack:
		__init_via_UnitAttack(_param, eff)
	elif _param is Attack:
		__init_via_Attack(_param)
	else:
		push_error(
			"Invalid data type passed to Attack constructor! UnitAttack or Attack expected but %s found!"\
			% type_string( typeof(_param) )
		)
		return
	
	#target_spots = _spots
	default_damage = dmg
	
	for spot: UnitSpot in _spots:
		var ref: UnitSpotReference = UnitSpotReference.new(spot)
		#damages[ref] = dmg
		target_references.append(ref)
