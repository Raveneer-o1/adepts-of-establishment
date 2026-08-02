extends BasePolicy

func apply_phantom(unit: Unit) -> void:
	unit.parameters.apply_effect(
		"Phantom",
		[GlobalDefs.AttackType.Physical, 1]
	)

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs := attack.target_references
	for ref: UnitSpotReference in attack.target_references:
		if not ref: continue
		if ref.spot == attack.attacker.spot:
			apply_phantom(attack.attacker)
			new_refs.erase(ref)
			if not attack.is_heal: attack.reverse_healing_flag()
