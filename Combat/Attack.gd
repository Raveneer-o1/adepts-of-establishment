class_name Attack

var damage: int
var accuracy: float
var type: EventBus.AttackType
var attacker: Unit
var targets: Array[Unit]
var effect: Resource

func resolve(finalize: bool = false) -> void:
	var i := 1
	for target in targets:
		target.resolve_attack(self, i, finalize)
		i += 1

func _init(_attacker: Unit, _targets: Array[Unit],
		dmg: int, ty: EventBus.AttackType,
		_accuracy: float, eff: Resource = null) -> void:
	type = ty
	attacker = _attacker
	targets = _targets
	damage = dmg
	accuracy = _accuracy
	effect = eff
