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
## [kbd]res://Combat/Effects/AppliedEffects/Scenes/[/kbd].
## This is used by the game to dynamically load the effect.[br]
## [code]value[/code]: A set of parameters passed to the effect. Parsed and handled
## within the respective effect class.
var applying_effects: Dictionary[String, Variant]

## Function with a signature
## [codeblock]
## (attacker: Unit, target: Unit, index: int, finalize: bool) -> void
## [/codeblock]
## Overrides [method Attack.resolve] and applies to all targets using their indexes
var damage_policy: BasePolicy

## Unlike [UnitAttack], this class does not perform any validation by dafault.
## This field is used by some effects (e.g. to redirect targets).
var validation: BaseValidation

var tags: Array[StringName] = []

var applied_damage: int = 0

var original: WeakRef = null

## Calles [method Unit.resolve_attack] on each of its targets
func resolve(finalize: bool = false) -> void:
	if damage_policy:
		damage_policy.apply_policy(self, finalize)
	else:
		standard_resolution(finalize)
	EventBus.attack_resolved.emit(self)

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

## Returns the first reference to the [param target] in [member damages]
func find_all_references(target: UnitSpot) -> Array[UnitSpotReference]:
	var result: Array[UnitSpotReference] = []
	for t: UnitSpotReference in target_references:
		if t.spot == target: result.append(t)
	return result

## Returns the first reference to the [param target] in [member damages]
func find_reference(target: UnitSpot) -> UnitSpotReference:
	for t: UnitSpotReference in target_references:
		if t.spot == target: return t
	return null

## Returnes a shallow copy of the object. All nested Array, Dictionary and Object elements are shared 
## with the original. Modifying them in one object will also affect them in the other.
func duplicate() -> Attack:
	var result := Attack.new(self, target_spots, default_damage)
	result.damages = damages
	result.target_references = target_references
	if damage_policy:
		result.damage_policy = damage_policy
	if applying_effects:
		result.applying_effects = applying_effects
	result.original = original if original else weakref(self)
	result.targets_chosen = targets_chosen
	return result

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
	validation = _unit_attack.target_validation
	targets_chosen = _unit_attack.targets_needed
	
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
	
	target_spots = _spots
	default_damage = dmg
	
	for spot: UnitSpot in _spots:
		var ref: UnitSpotReference = UnitSpotReference.new(spot)
		damages[ref] = dmg
		target_references.append(ref)
