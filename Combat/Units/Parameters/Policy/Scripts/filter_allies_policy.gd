extends BasePolicy


func _apply_policy(attack: Attack, finalize: bool) -> void:
	for ref in attack.target_references:
		if ref.spot.party == attack.attacker.party:
			attack.damages[ref] = 0
	attack.standard_resolution(finalize)
