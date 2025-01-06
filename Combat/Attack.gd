#extends Object
class_name Attack

var damage: int
var accuracy: float
var type: EventBus.AttackType
var attacker: Unit
var targets: Array[Unit]
var effect: Resource

var applying_effects: Dictionary

## Function with a signature [codeblock](attacker: Unit, target: Unit, index: int, finalize: bool) -> void[/codeblock]
## Overrides [method Attack.resolve] and applies to all targets using their indexes
var damage_policy: Callable

## Calles [method Unit.resolve_attack] on each of its targets
func resolve(finalize: bool = false) -> void:
	# if standart attack resolution if overridden
	if damage_policy:
		for i in range(targets.size()):
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
		targets,
		damage,
		type,
		accuracy,
		effect
	)
	if damage_policy:
		result.damage_policy = damage_policy
	return result

func _init(_attacker: Unit, _targets: Array[Unit],
		dmg: int, ty: EventBus.AttackType,
		_accuracy: float, eff: Resource = null) -> void:
	type = ty
	attacker = _attacker
	targets = _targets
	damage = dmg
	accuracy = _accuracy
	effect = eff
