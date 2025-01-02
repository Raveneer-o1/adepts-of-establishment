extends UnitParameters

func _set_attacks() -> void:
	var attack: UnitAttack = UnitAttack.new(1, false, false, Callable(), EventBus.AttackType.Physical, 0.8)
	attacks.append(attack)
