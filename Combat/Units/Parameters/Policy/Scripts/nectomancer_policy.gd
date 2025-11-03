extends BasePolicy

@export var decay_rate: float = 0.4
@export var resurrection_with_percent_hp: float = -1.0

func _apply_policy(attack: Attack, finalize: bool) -> void:
	if not attack.targets: return
	var first_position: int = attack.targets[0].party_position
	var new_refs: Array[UnitSpotReference] = []
	for t: UnitSpotReference in attack.target_references:
		if not t.spot: continue
		
		# dealing damage
		if t.spot.party != attack.attacker.party:
			var distance: int = Party.get_distance(first_position, t.spot.party_position)
			var dmg: int = attack.damages[t] if attack.damages.has(t) else attack.default_damage
			@warning_ignore("narrowing_conversion")
			dmg *= pow(decay_rate, distance)
			attack.damages[t] = dmg
			new_refs.append(t)
		
		# resurrecting
		else:
			if t.spot.corpse_container.get_child_count() == 0: continue
			var unit: Unit = t.spot.corpse_container.get_children().pick_random()
			unit.resurrect()
			if resurrection_with_percent_hp > 0.0:
				unit.heal( ceili(resurrection_with_percent_hp * unit.parameters.max_hp) )
	attack.target_references = new_refs
	attack.standard_resolution(finalize)
