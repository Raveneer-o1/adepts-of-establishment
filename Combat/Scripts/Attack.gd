#extends Object
class_name Attack


var damages: Dictionary # <target: UnitSpotReference, damage: int>

# if target can't be found in damages dictionary, this value will be used as damage
var default_damage: int

var redirected: bool = false

var accuracy: float
var type: EventBus.AttackType
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

var evadable: bool

## Dictionary containing elements in the format: <effect_name: String, params: Variant>[br]
## [code]effect_name[/code]: The name of a scene located in the folder 
## [kbd]res://Combat/Effects/AppliedEffects/Scenes/[/kbd]. This is used by the game to dynamically load the effect.[br]
## [code]params[/code]: A set of parameters passed to the effect. These are parsed and handled
## within the respective effect class.
var applying_effects: Dictionary

## Function with a signature [codeblock](attacker: Unit, target: Unit, index: int, finalize: bool) -> void[/codeblock]
## Overrides [method Attack.resolve] and applies to all targets using their indexes
var damage_policy: BasePolicy

## this foild is used be sime effect e.g. to redirect targets
var validation: BaseValidation

var tags: Array[StringName] = []

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
	return result

func __init_via_Attack(attack: Attack) -> void:
	type = attack.type
	attacker = attack.attacker
	accuracy = attack.accuracy
	evadable = attack.evadable
	effect = attack.effect
	validation = attack.validation

func __init_via_UnitAttack(_unit_attack: UnitAttack, eff: Resource) -> void:
	type = _unit_attack.type
	attacker = _unit_attack.unit
	accuracy = _unit_attack.accuracy
	evadable = _unit_attack.evadable
	validation = _unit_attack.target_validation
	
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
