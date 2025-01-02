extends UnitParameters

func _set_attacks() -> void:
	var attack: UnitAttack = UnitAttack.new(
			1, # damage_multiplier
			false, # damage_override
			false, # validation override
			Callable(), # empty validation
			EventBus.AttackType.Elemental,
			0.8 # accuracy
			)
	attacks.append(attack)
	check_target_validity = standart_archer_validity
