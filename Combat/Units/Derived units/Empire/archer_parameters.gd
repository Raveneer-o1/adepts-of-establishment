extends UnitParameters

func _set_attacks() -> void:
	attacks.append(UnitAttack.new(
			parent_unit, # unit reference
			1.0, # damage multiplier
			false, # damage override
			standart_archer_validity, # validation function
			EventBus.AttackType.Physical, # damage type
			0.85, # accuracy
			1, # number of targets
			50 # initiative
	))
