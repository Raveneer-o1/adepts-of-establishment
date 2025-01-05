#extends Object
class_name Attack

var damage: int
var accuracy: float
var type: EventBus.AttackType
var attacker: Unit
var targets: Array[Unit]
var effect: Resource

## function with a signature (attacker: Unit, target: Unit, index: int, finalize: bool) -> void
## overrides resolve_attack and applies to all targets using their indexes
var damage_policy: Callable

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
