extends BasePolicy

@export var decay_rate : float = 0.5

func _apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots[index].unit == null:
		return
	
	var first_position: int = attack.targets[0].party_position
	var target := attack.targets[index]
	var distance:int = Party.get_distance(first_position, target.party_position)
	
	var refs: Array[UnitSpotReference] = attack.target_references
	
	attack.damages[refs[index]] = roundi(
		attack.damages[refs[index]] * pow(decay_rate, distance)
	)
	var delay := index if index < attack.targets_chosen else attack.targets_chosen - 1
	target.resolve_attack(
		attack, 
		delay, 
		true
	)
