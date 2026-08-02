class_name Attack
extends RefCounted

## Attack that is being performed
##
## This class represents attacks in the proccess of being performed.
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

## Values in this dictionary override [member default_damage] for specific targets. [br]
## [b]Note:[/b] If a specific key exists in this dictionary but not in
## [member target_references], it will be ignored.
var damages: Dictionary[UnitSpotReference, int] = {}
## The main list of targets for this attack.
## This list takes precedence over the [member damages] dictionary.
##
## [b]Important:[/b] The array contains [UnitSpotReference] objects, not direct [UnitSpot]s.
## For the [member damages] dictionary to work correctly, its keys must correspond
## to the exact same [UnitSpotReference] instances used in this list. Creating new
## [UnitSpotReference] instances for the dictionary will not work — use
## [method find_reference] or [method find_all_references] to obtain the correct references.
var target_references: Array[UnitSpotReference] = []

## If target can't be found in [member damages] dictionary,
## this value will be used as damage
var default_damage: int

## Indicates whether this attack was redirected by calling 
## [method redirect_to], [method redirect_all], or [method deep_redirect].
var redirected: bool = false

## The chance this attack won't be missed
var accuracy: float
## Damage type
var type: GlobalDefs.AttackType
## The unit that initiatad the attack
var attacker: Unit
## List of all unit spots this attack is aimed at.
## This list is generated dynamically from [member target_references]
## and cannot be modified directly.
var target_spots: Array[UnitSpot]:
	get:
		var result: Array[UnitSpot] = []
		for ref: UnitSpotReference in target_references:
			if not ref: continue
			result.append(ref.spot)
		return result
## List of all units this attack is aimed at.
## This list is generated dynamically from [member target_references]
## and cannot be modified directly.
var targets: Array[Unit]:
	get:
		var result : Array[Unit] = []
		for ref: UnitSpotReference in target_references:
			if not ref: continue
			if ref.spot and ref.spot.unit:
				result.append(ref.spot.unit)
		return result
## The visual effect associated with this attack.
## This field is set to [member UnitAttack.effect_override] if present; otherwise,
## the [Attack] constructor must recieve it as an argument —
## [member UnitParameters.attack_effect] is not checked automatically.
## [br][br]
## This effect is instantiated as the target's child when the unit attacks.
## Intended for visual effects, though this resource undergoes no validation.
## The instantiated object is not tracked as it should free itself after animation
## completion. If using this for objects other than [TemporaryEffect],
## manual memory management is required.
var effect: Resource

## Number of targets selected by the player. Used for animation synchronization.[br]
## The first [b]targets_chosen[/b] damage numbers will be displayed as
## [signal EventBus.attack_reached] signals are emitted. All remaining effects
## are applied simultaneously with the final attack finalization.
## If the attack is finalized before [signal EventBus.attack_reached] has been
## emitted the expected number of times, all pending damage numbers are shown
## at once and subsequent signals are ignored.
var targets_chosen: int = 1

## Determines whether this attack can be evaded.
## When [code]false[/code], the evasion check is skipped during attack resolution
## [i](evasion logic is handled by the defending unit)[/i]
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

## Returns the [BaseAdditionalTargets] object from the original [UnitAttack].
## By default, this field is used only during full redirection
## (see [method deep_redirect]), but can be accessed directly if needed.
var additional_targets: BaseAdditionalTargets:
	get: return unit_attack.additional_targets

## Tags provide a flexible way to assign and check attack properties. Tags are not 
## automatically processed by the system, but they offer a convenient method for tracking
## various attack attributes. For example, see the [i]shielding[/i] mechanic and the 
## [code]&"shot"[/code] tag (documentation in the [Unit] class).
var tags: Array[StringName] = []

## if [code]true[/code], heals the target instead of applying damage
var is_heal: bool

## Cumulative damage dealt by this attack.[br]
## [b]Note:[/b] This field is zero until after
## [signal EventBus.attack_resolved] is emitted.
## Reading it before the signal will return [code]0[/code].
var applied_damage: int = 0

## Tracks total damage dealt by this attack to individual [Unit]s.
## A unit not present in this dictionary did not receive any damage from this attack.
var damage_dealt: Dictionary[Unit, int] = {}

var _preserved_first_target: UnitSpotReference = null

func _remove_target(ref: UnitSpotReference) -> void:
	# Using null references instead of erase() to preserve the original order
	# Primarily maintains first entry indices for the is_primary_target() method
	var i := target_references.find(ref)
	if not _preserved_first_target and i == 0:
		_preserved_first_target = target_references[i]
	target_references[i] = null

func _check_immunity(ref: UnitSpotReference) -> bool:
	var unit := ref.spot.unit
	if not unit: return false
	if type == GlobalDefs.AttackType.None: return false
	if type not in unit.parameters.immunities: return false
	
	ref.spot.system.display_text_near_unit(unit, "Immunity")
	unit.sound_player.play_immunity_sound()
	tags.append(&"immuned")
	_remove_target(ref)
	GlobalLogger.add_message("Attack immuned by %s" % str(unit), self)
	return true

func _check_miss(ref: UnitSpotReference) -> bool:
	var unit := ref.spot.unit
	if not unit: return false
	var success := GlobalDefs.rand_roll(
		accuracy, 
		unit.party if is_heal else unit.party.other_party
	)
	if success: return false
	
	unit.system.display_text_near_unit(unit, "Miss!")
	EventBus.attack_missed.emit(unit, self)
	attacker.sound_player.play_miss_sound()
	tags.append(&"missed")
	GlobalLogger.add_message("Attack missed on %s" % str(unit), self)
	_remove_target(ref)
	return true

func _check_ward(ref: UnitSpotReference) -> bool:
	var unit := ref.spot.unit
	if not unit: return false
	if self not in unit.warded_attacks: return false
	
	unit.system.display_text_near_unit(unit, "Ward!")
	unit.sound_player.play_shield_sound()
	tags.append(&"warded")
	GlobalLogger.add_message("Attack warded by %s" % str(unit), self)
	_remove_target(ref)
	return true


## Filters targets by removing immune units and calculating misses based on accuracy.
## Processes each target reference to determine validity before damage application.
func filter_targets() -> void:
	# original target_references could be modified, creating a duplicate
	# NOTE: this should not work without the diplicate() and yet it does?
	var refs: Array[UnitSpotReference] = target_references.duplicate()
	for ref in refs:
		var unit := ref.spot.unit
		if not unit: continue
		if _check_immunity(ref): continue
		# Check ward before miss/evade because warded_attacks is already 
		# populated at this point and 'ward' effect is removed
		if _check_ward(ref): continue
		if _check_miss(ref): continue
		# Evasion is handled within the unit's resolution logic
		
		# the "_check" functions handle the all the logic related to modifying
		# the related parameters, there's nothing else to do here

## Filters out immune, warded, and missed targets, then resolves the attack.
## Applies [member damage_policy] if defined, otherwise calls [method Unit.resolve_attack]
## on each remaining valid target.
func resolve(finalize: bool = false) -> void:
	GlobalLogger.add_message("Attack is being resolved", self)
	filter_targets()
	if damage_policy:
		damage_policy.apply_policy(self, finalize)
	else:
		standard_resolution(finalize)
	EventBus.attack_resolved.emit(self)

## Registers and stores damage dealt to the specified [param unit].
## Does not validate whether [param unit] is a valid target for this attack.
func register_applied_damage(unit: Unit, damage: int) -> void:
	applied_damage += damage
	if damage_dealt.has(unit):
		damage_dealt[unit] += damage
	else: damage_dealt[unit] = damage

## Executes the default attack resolution algorithm.
## Call this method from a policy object when the policy modifies 
## values without changing the attack behavior.
func standard_resolution(finalize: bool = false) -> void:
	var i := 1
	for target in target_references:
		if ( \
			not target or \
			not target.spot or \
			not target.spot.unit or \
			target.spot.unit.parameters.dead \
		): continue
		var damage_to_take: int = damages[target] if damages.has(target) else default_damage
		target.spot.unit.resolve_attack(self, damage_to_take, i, finalize)
		if i < targets_chosen:
			i += 1

#func set_parameters(attack: UnitAttack) -> void:
	#damage_policy = attack.damage_policy
	#applying_effects = attack.applying_effects.duplicate()

## Redirects a single target of this attack from
## [param target_ref] to the [param to] spot. [br][br]
## To locate the target reference, use [method find_reference]
## or [method find_all_references]. [br][br]
## For other redirection behaviors,
## see [method redirect_all] and [method deep_redirect].
func redirect_to(target_ref: UnitSpotReference, to: UnitSpot) -> void:
	var index: int = target_references.find(target_ref)
	if index < 0: return
	
	var new_ref := UnitSpotReference.new(to)
	
	target_references[index] = new_ref
	if target_ref in damages:
		var damage: int = damages[target_ref]
		damages.erase(target_ref)
		damages[new_ref] = damage
	redirected = true

## Redirects all individual target spots to a single new target.
## Additional targets are not recalculated (e.g., splash damage will be consolidated
## onto the single unit rather than redistributed to new targets).
## To properly recalculate additional targets and their damage, use [method deep_redirect].
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

## Returns the list of all references to the [param target] in [member target_references].
## Returns an empty list if there is none.
func find_all_references(target: UnitSpot) -> Array[UnitSpotReference]:
	var result: Array[UnitSpotReference] = []
	for t: UnitSpotReference in target_references:
		if t.spot == target: result.append(t)
	return result

## Returns the first reference to the [param target] in [member target_references].
## Returns [code]null[/code] if there is none.
func find_reference(target: UnitSpot) -> UnitSpotReference:
	for t: UnitSpotReference in target_references:
		if t and t.spot == target: return t
	return null

## Returns if [param target] was chosen by a player.
func is_primary_target(target: UnitSpot) -> bool:
	var pos := target_spots.find(target)
	return pos >= 0 and pos < targets_chosen

func find_first_primary_target() -> UnitSpotReference:
	if not target_references:
		return null
	if target_references.size() < targets_chosen:
		push_error("targets_chosen is larger than target_references size!")
		return null
	if _preserved_first_target: return _preserved_first_target
	for i in range(targets_chosen):
		if target_references[i]: return target_references[i]
	return null

func __init_via_UnitAttack(_unit_attack: UnitAttack, eff: Resource) -> void:
	type = _unit_attack.type
	attacker = _unit_attack.unit
	accuracy = _unit_attack.accuracy
	evadable = _unit_attack.evadable
	unit_attack = _unit_attack
	targets_chosen = _unit_attack.targets_needed
	is_heal = _unit_attack.is_heal
	tags.append_array(_unit_attack.tags)
	
	if _unit_attack.effect_override:
		effect = _unit_attack.effect_override
	else:
		effect = eff

func _init(_unit_attack: UnitAttack, _spots: Array[UnitSpot],
		dmg: int, eff: Resource = null) -> void:
	__init_via_UnitAttack(_unit_attack, eff)
	
	default_damage = dmg
	
	for spot: UnitSpot in _spots:
		var ref: UnitSpotReference = UnitSpotReference.new(spot)
		target_references.append(ref)
	

func _to_string() -> String:
	var d: Dictionary = {
		"attacker": attacker,
		"is_heal": is_heal,
		"type": type,
		"accuracy": accuracy,
		"evadable": evadable,
		#"unit_attack": unit_attack,
		"targets_chosen": targets_chosen,
		"targets": targets,
	}
	return "Attack %s" % str(d)
