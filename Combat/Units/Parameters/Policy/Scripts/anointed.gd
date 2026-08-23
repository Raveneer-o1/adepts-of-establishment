extends BasePolicy

@export var ally_damage_reduction := 0.4
@export var splash_damage_reduction := 0.6

func _apply_policy(attack: Attack, finalize: bool) -> void:
	for ref in attack.target_references:
		if not ref or not ref.spot: continue
		if ref.spot.party == attack.attacker.party:
			var dmg: int = attack.damages.get(ref, attack.default_damage)
			attack.damages[ref] = roundi(dmg * ally_damage_reduction)
		elif not attack.is_primary_target_reference(ref):
			var dmg: int = attack.damages.get(ref, attack.default_damage)
			attack.damages[ref] = roundi(dmg * splash_damage_reduction)
	attack.standard_resolution(finalize)
