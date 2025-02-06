extends BasePolicy

@export var decay_rate: float = 0.4
@export var resurrection_with_percent_hp: float = -1.0

# Copy of the decay_policy
func deal_damage(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots[index].unit == null:
		return
	
	var first_position: int = attack.targets[0].party_position
	var target := attack.targets[index]
	var distance:int = Party.get_distance(first_position, target.party_position)
	
	if attack.damages.has(target.spot):
		@warning_ignore("narrowing_conversion") attack.damages[target.spot] *= pow(decay_rate, distance)
	else:
		print_debug("%s's spot is not found in the attack's Dictionary!" % target.unit_name)
	target.resolve_attack(attack, index + 1, true)

# Copy of the resurrection_policy
func resurrect(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots[index].unit != null:
		return
	var corpse_container: Node = attack.target_spots[index].corpse_container
	if corpse_container.get_child_count() == 0:
		return
	
	var unit: Unit = corpse_container.get_child(0)
	unit.resurrect()
	if resurrection_with_percent_hp > 0.0:
		unit.heal(resurrection_with_percent_hp * unit.parameters.max_hp - 1)

func _apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets[index].party != attack.attacker.party:
		deal_damage(attack, index, finalize)
	else:
		resurrect(attack, index, finalize)
