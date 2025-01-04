extends Unit
class_name MageUnit

func all_units_filter(unit: Unit) -> bool:
	if unit == null:
		return false
	if unit.parameters.dead:
		return false
	return true
	

func _start_attacking() -> void:
	if parameters.attacks.size() == 0:
		return
	
	anim_handle.play_attack_animation()
	#var u_attack: UnitAttack = parameters.attacks[0]
	#var attacks_to_book: Array[Attack] = []

	#for u in party.other_party.get_units_custom(all_units_filter):
		#var dmg: int
		#if u_attack.damage_override:
			#@warning_ignore("narrowing_conversion") dmg = u_attack.damage_multiplier
		#else:
			#@warning_ignore("narrowing_conversion") dmg = u_attack.damage_multiplier * parameters.base_damage
		#
		#var attack: Attack = Attack.new(
				#self, # attacker
				#u, # target
				#dmg, # damage
				#u_attack.type, #attack type
				#randf() > u_attack.accuracy, # if attack is missed
				#parameters.attack_effect
		#)
		#
		#attacks_to_book.append(attack)
	
	var targets := party.other_party.get_units_custom(all_units_filter)
	var dmg: int = current_attack.damage_multiplier if current_attack.damage_override else\
			current_attack.damage_multiplier * parameters.base_damage
	
	var attack: Attack = Attack.new(
			self, # attacker
			targets,
			dmg,
			current_attack.type,
			current_attack.accuracy,
			parameters.attack_effect
	)
	
	system.combat_logic.book_damage(attack)
