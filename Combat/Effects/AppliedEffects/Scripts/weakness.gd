extends AppliedEffect

var turns: int = 0
var damage_decrease: int

func _get_description() -> String:
	# Unit's damage is decreased by %d for %d turns
	return description % [damage_decrease, turns]


# Reduces the number of remaining turns and removes the effect when expired
func count_turn(unit: Unit) -> void:
	if unit == target_unit:
		turns -= 1
		if turns <= 0:
			lift_effect()


## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if params is Array:
		if params.size() == 2:
			turns = params[0]
			damage_decrease = params[1]
		else:
			print_debug("Invalid number parameter for a '%s' effect. Expected 2, found %d!" % [effect_name, params.size()])
	else:
		print_debug("Invalid parameter for a '%s' effect. Expected array, found %s!" % [ effect_name, type_string(typeof(params)) ] )
	
	if turns <= 0:
		lift_effect()
		return
	
	EventBus.turn_started.connect(count_turn)
	
	target_unit.parameters.add_modifier(
		"base_damage",
		self, 
		func (damage: int) -> int:
			return damage - damage_decrease)
