class_name Attack

var damage: int
var whiff: bool
var type: EventBus.AttackType
var attacker: Unit
var target: Unit

func _init(_attacker: Unit, _target: Unit, dmg: int, ty: EventBus.AttackType, wh: bool) -> void:
	type = ty
	attacker = _attacker
	target = _target
	damage = dmg
	whiff = wh
