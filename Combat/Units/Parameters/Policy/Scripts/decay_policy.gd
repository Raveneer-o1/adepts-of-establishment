extends BasePolicy

@export var decay_rate : float = 0.5

func apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	
	var first_position: int = attack.targets[0].party_position
	var target := attack.targets[index]
	var distance:int = Party.get_distance(first_position, target.party_position)
	
	@warning_ignore("narrowing_conversion") attack.damage *= pow(decay_rate, distance)
	target.resolve_attack(attack, index + 1, true)
