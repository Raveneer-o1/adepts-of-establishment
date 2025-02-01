extends AppliedEffect

@export var buff: float
@export var turns: int = 2

func _get_description() -> String:
	#print(description)
	var percent: int = (round((buff - 1.0) * 100) if buff > 1.0 \
			else 0)
	#print(percent)
	return description % percent
			


func trigger_effect(unit: Unit, attack: Attack) -> void:
	if unit != target_unit:
		return
	
	var params: Dictionary = {
		"parameter": &"base_damage",
		"turns": turns,
		"multiplier": buff
	}
	target_unit.parameters.apply_effect("temporary_buff", params)


## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_evaded] = trigger_effect
