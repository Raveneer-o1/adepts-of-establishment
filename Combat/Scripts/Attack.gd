#extends Object
class_name Attack


var damages: Dictionary # <target: UnitSpot, damage: int>

# if target can't be found in damages dictionary, this value will be used as damage
var default_damage: int

var accuracy: float
var type: EventBus.AttackType
var attacker: Unit
var target_spots: Array[UnitSpot]:
	get:
		var result: Array[UnitSpot] = []
		@warning_ignore("untyped_declaration")
		for key in damages.keys():
			if key is UnitSpot:
				result.append(key)
			else:
				print_debug(\
					"Unexpected type in the tarrets of an Attack object! UnitSpot expected, but %s found!" \
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

## Returnes a shallow copy of the object. All nested Array, Dictionary and Object elements are shared 
## with the original. Modifying them in one object will also affect them in the other.
func duplicate() -> Attack:
	var result := Attack.new(
		attacker,
		target_spots,
		0,
		type,
		accuracy,
		effect,
		evadable
	)
	result.damages = damages
	if damage_policy:
		result.damage_policy = damage_policy
	if applying_effects:
		result.applying_effects = applying_effects
	return result

func _init(_attacker: Unit, _spots: Array[UnitSpot],
		dmg: int, ty: EventBus.AttackType,
		_accuracy: float, eff: Resource = null,
		_evadable: bool = true) -> void:
	type = ty
	attacker = _attacker
	target_spots = _spots
	accuracy = _accuracy
	effect = eff
	evadable = _evadable
	default_damage = dmg
	for spot: UnitSpot in _spots:
		damages[spot] = dmg
