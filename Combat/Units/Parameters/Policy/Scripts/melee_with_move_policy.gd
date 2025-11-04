extends BasePolicy

@export var melee_validation: BaseValidation

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs := attack.target_references.duplicate()
	for t in attack.target_references:
		if melee_validation.validate_target(attack.attacker, t.spot): continue
		var valid_spots := []
		for s: UnitSpot in attack.attacker.party.unit_spots:
			if melee_validation.validate_position_pair(s, t.spot):
				var dist := Party.get_distance(s.party_position, attack.attacker.party_position)
				valid_spots.append([s, dist])
		valid_spots.sort_custom(
			func (a: Array, b: Array) -> bool:
				return a[1] < b[1]
		)
		var moved: bool = false
		for valid_spot: Array in valid_spots:
			if attack.attacker.system.try_moving_unit(
				attack.attacker, 
				(valid_spot[0] as UnitSpot).party_position
			):
				moved = true
				break
		if moved: break
		new_refs.erase(t)
	attack.target_references = new_refs
	attack.standard_resolution(finalize)
