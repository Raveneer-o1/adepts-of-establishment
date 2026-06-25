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

const MAX_ADJACENT_UNITS = 4

func get_full_damage_potential(attack: UnitAttack) -> float:
	assert(attack, "Null attack detected")
	var targets_number := attack.expected_targets()
	if targets_number == 0: return 0.0
	var damage := attack.get_actual_damage()
	if targets_number == 1: return damage
	var total := damage
	
	for i in range(MAX_ADJACENT_UNITS):
		total += damage * decay_rate
		
		targets_number -= 1
		# targets_number should be 1 at the end as tha last one if the primary target itself
		if targets_number <= 1: break
	
	var decay_rate_sq := decay_rate * decay_rate
	while targets_number > 1:
		total += damage * decay_rate_sq
		
		targets_number -= 1
	
	return total * clampf(attack.accuracy, 0.0, 1.0)
