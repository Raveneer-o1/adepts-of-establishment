extends BasePolicy


func _apply_policy(attack: Attack, finalize: bool) -> void:
	var unit: Unit = null
	for u in attack.targets:
		if u: unit = u; break
	if not unit: return
	
	# FIXME: this assumes that the animation is ongoing
	# will lock the game if that's not the case
	# should make emitting frames conditional to the animation index
	await attack.attacker.animation_handle.animation_changed
	
	attack.attacker.parameters.apply_effect(
		"polymorph", 
		[unit],
		true,
		true,
		true
	)

# If the policy modifies attack damage values (which is the case for most policies),
# uncomment and implement the method below.
# This is the default base class implementation.
#func get_full_damage_potential(attack: UnitAttack) -> float:
	#assert(attack, "Null attack detected")
	#return \
		#attack.expected_targets() * \
		#attack.get_actual_damage() * \
		#clampf(attack.accuracy, 0.0, 1.0)
