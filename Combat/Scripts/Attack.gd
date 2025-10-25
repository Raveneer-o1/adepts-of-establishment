class_name Attack

## Attack that is being performed
##
## This class manages attacks tha are in the proccess of being performed.
## Each [Attack] does through a series of stages: [br]
## 1. [b]Target Validation[/b]: The player/AI selects valid targets based on attack rules
## (see [UnitAttack.target_validation], class [BaseValidation]).[br]
## 2. [b]Attack Booking[/b]: An [Attack] instance is created and queued for resolution. This emits
## [signal EventBus.attack_booked].[br]
## 3. [b]Effect Application[/b]: Effects connected to [signal EventBus.attack_booked]
## can modify the booked attack.[br]
## 4. [b]Resolution[/b]: When the animation reaches its first active frame
## (set via [member UnitAnimationsHandle.frames_to_emit]), all attacks are resolved.[br]
## 5. [b]Finalization[/b]: In some cases, it might be necessary to delay the visual
## representation of the attack results (e.g., when there are two active frames, you
## might want to delay the second damage number until the second hit actually connects).
## In this case, the unit will store the resolved attack
## but not finalize it until [signal EventBus.attack_reached] is emitted again.[br]
## [color=lightgreen]Note: The unit's combat stats are currently modified inside
## [method Unit.finalize_attack]. This is a temporary workaround. The intended design is
## for this function to only handle visual updates, while the actual combat calculations
## should happen during the resolution phase.[/color][br]
## 6. [b]Cleanup[/b]: The next attack from the [i]action queue[/i] is popped and moved to
## [member CombatLogic.current_attack].[br][br]
##
## [b]See also:[/b] [CombatSystem], [UnitAttack], [Unit]

var damages: Dictionary # <target: UnitSpotReference, damage: int>

# if target can't be found in damages dictionary, this value will be used as damage
var default_damage: int

var redirected: bool = false

var accuracy: float
var type: GlobalDefs.AttackType
var attacker: Unit
var target_references: Array[UnitSpotReference]:
	get:
		var result: Array[UnitSpotReference] = []
		@warning_ignore("untyped_declaration")
		for key in damages.keys():
			if key is UnitSpotReference:
				result.append(key)
			else:
				print_debug(\
					"Unexpected type in the targets of an Attack object! UnitSpotReference expected, but %s found!" \
					% type_string( typeof(key) )
				)
		return result
var target_spots: Array[UnitSpot]:
	get:
		var result: Array[UnitSpot] = []
		@warning_ignore("untyped_declaration")
		for key in damages.keys():
			if key is UnitSpotReference:
				result.append(key.spot)
			else:
				print_debug(\
					"Unexpected type in the targets of an Attack object! UnitSpotReference expected, but %s found!" \
					% type_string( typeof(key) )
				)
		return result
var targets: Array[Unit]:
	set(value):
		target_spots = []
		for unit in value:
			if unit != null:
				target_spots.append(unit.spot)
	get:
		var result : Array[Unit] = []
		for spot in target_spots:
			if spot.unit != null:
				result.append(spot.unit)
		return result
var effect: Resource

## Number of targets selected by the player. Used for animation synchronization.[br]
## The first [b]targets_chosen[/b] damage numbers will display as [signal EventBus.attack_reached]
## signals are emitted, while all other effects are applied simultaneously with the last finalization.
var targets_chosen: int = 1

var evadable: bool

## Dictionary containing elements in the format: <effect_name: String, params: Variant>[br]
## [code]effect_name[/code]: The name of a scene located in the folder 
## [kbd]res://Combat/Effects/AppliedEffects/Scenes/[/kbd]. This is used by the game to dynamically load the effect.[br]
## [code]params[/code]: A set of parameters passed to the effect. These are parsed and handled
## within the respective effect class.
var applying_effects: Dictionary

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

var original: Attack = null

## Calles [method Unit.resolve_attack] on each of its targets
func resolve(finalize: bool = false) -> void:
	# if standart attack resolution if overridden
	if damage_policy:
		for i in range(target_spots.size()):
			damage_policy.apply_policy(self.duplicate(), i, finalize)
		return
	
	# standart attack resolution
	var i := 1
	for target in targets:
		target.resolve_attack(self, i, finalize)
		if i < targets_chosen:
			i += 1

func set_parameters(attack: UnitAttack) -> void:
	damage_policy = attack.damage_policy
	applying_effects = attack.applying_effects.duplicate()

func redirect_to(target_index: UnitSpotReference, target_unit:Unit) -> void:
	var damage: int = damages[target_index]
	var new_index := UnitSpotReference.new(target_unit.spot)
	damages.erase(target_index)
	damages[new_index] = damage
	redirected = true

## Returnes a shallow copy of the object. All nested Array, Dictionary and Object elements are shared 
## with the original. Modifying them in one object will also affect them in the other.
func duplicate() -> Attack:
	var result := Attack.new(self, target_spots, default_damage)
	result.damages = damages
	if damage_policy:
		result.damage_policy = damage_policy
	if applying_effects:
		result.applying_effects = applying_effects
	result.original = original if original else self
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
