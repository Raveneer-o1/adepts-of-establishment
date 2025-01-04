extends UnitParameters

func _set_attacks() -> void:
	attacks.append(UnitAttack.new(
			parent_unit, # unit reference
			1.5, # damage multiplier
			false, # damage override
			standart_archer_validity, # validation function
			EventBus.AttackType.Elemental, # damage type
			0.85, # accuracy
			1, # number of targets
			70 # initiative
	))
	attacks.append(UnitAttack.new(
			parent_unit, # unit reference
			1.1, # damage multiplier
			false, # damage override
			standart_archer_validity, # validation function
			EventBus.AttackType.Elemental, # damage type
			0.85, # accuracy
			1, # number of targets
			60 # initiative
	))
