extends AppliedEffect

@export var heal: float

## if [code]true[/code], unit is healed by a percentage of damage dealt ([code]heal * attack.damage[/code])
## NOTE: heal would serve as multiplier, i.e. value of .1 would mean 10%
@export var is_percentage: bool


func _get_description() -> String:
	return description % [heal,
		"%% of damage as" if is_percentage \
		else ""
	]


func vampiric_heal(attack: Attack) ->void:
	if attack.attacker == target_unit:
		@warning_ignore("narrowing_conversion")
		target_unit.heal(
			heal * attack.damage if is_percentage \
			else heal
		)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = vampiric_heal
	
