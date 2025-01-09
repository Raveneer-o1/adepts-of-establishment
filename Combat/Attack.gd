#extends Object
class_name Attack

var damage: int
var accuracy: float
var type: EventBus.AttackType
var attacker: Unit
var target_spots: Array[UnitSpot]
var targets: Array[Unit]:
	set(value):
		for unit in value:
			if unit != null:
				target_spots.append(unit.get_parent())
	get:
		var result : Array[Unit] = []
		for spot in target_spots:
			if spot.unit != null:
				result.append(spot.unit)
		return result
var effect: Resource

var applying_effects: Dictionary

## Function with a signature [codeblock](attacker: Unit, target: Unit, index: int, finalize: bool) -> void[/codeblock]
## Overrides [method Attack.resolve] and applies to all targets using their indexes
var damage_policy: Callable

## Calles [method Unit.resolve_attack] on each of its targets
func resolve(finalize: bool = false) -> void:
	# if standart attack resolution if overridden
	if damage_policy:
		for i in range(target_spots.size()):
			damage_policy.call(self.duplicate(), i, finalize)
		return
	
	# standart attack resolution
	var i := 1
	for target in targets:
		target.resolve_attack(self, i, finalize)
		i += 1

## Returnes a shallow copy of the object. All nested Array, Dictionary and Object elements are shared 
## with the original. Modifying them in one object will also affect them in the other.
func duplicate() -> Attack:
	var result := Attack.new(
		attacker,
		target_spots,
		damage,
		type,
		accuracy,
		effect
	)
	if damage_policy:
		result.damage_policy = damage_policy
	if applying_effects:
		result.applying_effects = applying_effects
	return result

func _init(_attacker: Unit, _spots: Array[UnitSpot],
		dmg: int, ty: EventBus.AttackType,
		_accuracy: float, eff: Resource = null) -> void:
	type = ty
	attacker = _attacker
	target_spots = _spots
	damage = dmg
	accuracy = _accuracy
	effect = eff
