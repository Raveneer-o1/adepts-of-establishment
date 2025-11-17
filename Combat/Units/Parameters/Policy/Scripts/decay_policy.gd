extends BasePolicy

@export var decay_rate : float = 0.7

func _apply_policy(attack: Attack, finalize: bool) -> void:
	if not attack.targets: return
	var first_target := attack.find_first_primary_target()
	if not first_target:
		push_error("Unable to find first target!")
		attack.standard_resolution(true)
		return
	
	var first_position: int = first_target.spot.party_position
	for target in attack.target_references:
		if not target: continue
		if not target.spot: continue
		var distance: int = Party.get_distance(first_position, target.spot.party_position)
		var dmg: int = attack.damages[target] if attack.damages.has(target) else attack.default_damage
		@warning_ignore("narrowing_conversion")
		dmg *= pow(decay_rate, distance)
		attack.damages[target] = dmg
	attack.standard_resolution(true)
