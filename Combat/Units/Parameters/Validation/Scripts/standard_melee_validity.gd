extends BaseValidation

func validate_position_pair(attacker_spot: UnitSpot, target_spot: UnitSpot) -> bool:
	if attacker_spot == null or \
		target_spot == null or \
		target_spot.unit == null:
		return false
	if target_spot.unit.parameters.dead:
		return false
	# if units are in the same party, we don't attack
	if attacker_spot.party == target_spot.party:
		return false
	
	var target := target_spot.unit
	var pos := attacker_spot.party_position
	var targets : Array[Unit]
	# step of 2 indicates adjacent units *see Party class documentation*
	var step: int = 2
	
	if attacker_spot.unit and attacker_spot.unit.parameters.large_unit and pos % 2 != 0:
		step = 1
		targets = attacker_spot.party.other_party.get_units_at_positions(
			[pos - step, pos + step],
			false
		)
		if targets.has(target):
			return true
		
		# if at least one value is returned, target is blocked by that unit
		if targets: return false
	else:
		# even position indicates front line
		if pos % 2 == 0:
			# check position in front and adjacent positions
			targets = attacker_spot.party.other_party.get_units_at_positions(
				[pos - step, pos, pos + step],
				false
			)
			if targets.has(target):
				return true
			
			# if at least one value is returned, target is blocked by that unit
			if targets: return false
		
		# odd position indicates back line
		else:
			if not attacker_spot.party.front_line_is_empty():
				return false
			# set new pos to check front line first
			step = -1
	
	
	# assuming we can't get out of bounds on the first check
	var in_bounds: bool = true
	while in_bounds:
		step += 2
		
		targets = attacker_spot.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
		# if get_units_at_positions() returned 2 nulls, we're completely out of bounds
		if targets.size() == 2:
			in_bounds = false
	
	# === Checking back line ===
	
	# even position indicates front line
	if pos % 2 == 0:
		step = 1
	
	# odd position indicates back line
	else:
		step = 2
		targets = attacker_spot.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
	
	
	in_bounds = true
	while in_bounds:
		targets = attacker_spot.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
		# if get_units_at_positions() returned 2 nulls, we're completely out of bouns
		if targets.size() == 2:
			in_bounds = false
		
		step += 2
	
	return false
