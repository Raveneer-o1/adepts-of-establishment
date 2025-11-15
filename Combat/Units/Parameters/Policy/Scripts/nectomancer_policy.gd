extends BasePolicy

@export var decay_rate: float = 0.4
@export var resurrection_with_percent_hp: float = -1.0

@export var resurrection_cost: int = 30
@export var message: String = "Blood price"
@export var color: Color = Color(0.8, 0.1, 0.1)

func _apply_policy(attack: Attack, finalize: bool) -> void:
	if not attack.target_references: return
	var first_position: int = attack.target_references[0].spot.party_position
	var new_refs: Array[UnitSpotReference] = []
	for t: UnitSpotReference in attack.target_references:
		if not t.spot: continue
		
		# resurrecting
		if t.spot.party == attack.attacker.party:
			if t.spot.corpse_container.get_child_count() == 0: continue
			var unit: Unit = t.spot.corpse_container.get_children().pick_random()
			if resurrection_cost > 0:
				attack.attacker.take_direct_damage(resurrection_cost, message, color)
			unit.resurrect()
			if resurrection_with_percent_hp > 0.0:
				unit.heal( ceili(resurrection_with_percent_hp * unit.parameters.max_hp) )
		
		# dealing damage
		else:
			var distance: int = Party.get_distance(first_position, t.spot.party_position)
			var dmg: int = attack.damages[t] if attack.damages.has(t) else attack.default_damage
			@warning_ignore("narrowing_conversion")
			dmg *= pow(decay_rate, distance)
			attack.damages[t] = dmg
			new_refs.append(t)
	attack.target_references = new_refs
	attack.standard_resolution(finalize)
