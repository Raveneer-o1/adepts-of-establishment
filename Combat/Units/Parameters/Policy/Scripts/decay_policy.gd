extends BasePolicy

@export var decay_rate : float = 0.5

func _apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots[index].unit == null:
		return
	
	var first_position: int = attack.targets[0].party_position
	var target := attack.targets[index]
	var distance:int = Party.get_distance(first_position, target.party_position)
	
	@warning_ignore("narrowing_conversion") 
	attack.damages[attack.target_spots[index]] *= pow(decay_rate, distance)
	target.resolve_attack(attack, index + 1, true)
