extends BasePolicy

@export var pushback_probability: float = 0.5

func _apply_pushback(attack: Attack) -> void:
	for ref in attack.target_references:
		if not ref or not ref.spot: continue
		if not Party.is_front_line(ref.spot.party_position): continue
		var system := CombatSystem.get_combat_system()
		var shift := signi(ref.spot.party_position - attack.attacker.party_position)
		if shift == 0: shift = 1
		if not system.try_moving_unit(ref.spot.unit, ref.spot.party_position + shift):
			system.try_moving_unit(ref.spot.unit, ref.spot.party_position - shift)

func _apply_policy(attack: Attack, finalize: bool) -> void:
	if GlobalDefs.rand_roll(pushback_probability):
		_apply_pushback(attack)
	attack.standard_resolution(finalize)
