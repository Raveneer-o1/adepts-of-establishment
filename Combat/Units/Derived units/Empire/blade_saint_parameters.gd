extends UnitParameters

func _set_attacks() -> void:
	attacks.append(UnitAttack.new(1.0, false, false, Callable(), EventBus.AttackType.Physical, 0.85))
	attacks.append(UnitAttack.new(1.2, false, false, Callable(), EventBus.AttackType.Physical, 0.95))
