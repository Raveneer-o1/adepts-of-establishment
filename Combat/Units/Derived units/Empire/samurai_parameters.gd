extends UnitParameters

func _set_attacks() -> void:
	attacks.append(UnitAttack.new(
			1, # damage_multiplier
			false, # damage_override
			false, # validation override
			Callable(), # empty validation
			EventBus.AttackType.Physical,
			0.8 # accuracy
			))
	attacks.append(UnitAttack.new(
			50, # damage_multiplier
			true, # damage_override
			false, # validation override
			Callable(), # empty validation
			EventBus.AttackType.Physical,
			0.85 # accuracy
			))
