extends BasePolicy

@export var decay_rate : float = 0.5

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var first_position: int = attack.targets[0].party_position
	for target in attack.target_references:
		if not target.spot: continue
		var distance: int = Party.get_distance(first_position, target.spot.party_position)
		var dmg: int = attack.damages[target] if attack.damages.has(target) else attack.default_damage
		@warning_ignore("narrowing_conversion")
		dmg *= pow(decay_rate, distance)
		attack.damages[target] = dmg
	attack.standard_resolution(true)
