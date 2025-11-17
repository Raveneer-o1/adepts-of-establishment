extends BasePolicy

@export var chance_to_purify_enemy: float = 0.5
@export var melee_validity: BaseValidation

func purify(unit: Unit) -> void:
	for effect in unit.parameters.get_all_effects():
		effect.lift_effect()

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs: Array[UnitSpotReference] = []
	var units_to_purify: Array[Unit] = []
	for ref in attack.target_references:
		if not ref: continue
		if not ref.spot: continue
		if ref.spot.party == attack.attacker.party:
			purify(ref.spot.unit)
			continue
		if not melee_validity or melee_validity.validate_target(attack.attacker, ref.spot):
			new_refs.append(ref)
			if GlobalDefs.rand_roll(chance_to_purify_enemy):
				units_to_purify.append(ref.spot.unit)
		else:
			units_to_purify.append(ref.spot.unit)
	attack.target_references = new_refs
	attack.standard_resolution(finalize)
	for u in units_to_purify:
		purify(u)
