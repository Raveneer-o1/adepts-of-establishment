extends BaseValidation

@export var melee_validation: BaseValidation
@export var max_move: int = 1

func validate_position_pair(attacker_spot: UnitSpot, target_spot: UnitSpot) -> bool:
	if not target_spot.unit: return false
	if target_spot.party == attacker_spot.party: return false
	if melee_validation.validate_position_pair(attacker_spot, target_spot): return true
	
	for party_spot in attacker_spot.party.unit_spots:
		var dist: int = Party.get_distance(party_spot.party_position, attacker_spot.party_position)
		if party_spot.unit: continue
		if dist > max_move: continue
		if melee_validation.validate_position_pair(party_spot, target_spot): return true
	
	return false
