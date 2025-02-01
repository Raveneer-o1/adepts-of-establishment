extends AppliedEffect

## Chance to perform the attack
@export var chance: float = 0.5


func _get_description() -> String:
	var percent: int = (round(chance * 100) if chance > 0.0 \
			else 0) if chance < 1.0 else 100
	#print(percent)
	return description % percent

func check_trigger(attack: Attack) -> void:
	if attack.targets.is_empty():
		return
	
	var target: Unit = attack.targets[0]
	
	if attack.attacker.party != target_unit.party or \
			attack.attacker == target_unit or \
			target.party == target_unit.party:
		return
	
	# if random check didn't pass, return
	if chance < randf():
		return
	
	
	target_unit.force_attack(target)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
