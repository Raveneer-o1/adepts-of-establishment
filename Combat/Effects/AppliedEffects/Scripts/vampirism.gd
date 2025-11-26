extends AppliedEffect

@export var heal: float

## if [code]true[/code], unit is healed by a percentage of damage dealt
## ([code]heal * attack.applied_damage[/code])
## [b]Note:[/b] heal would serve as multiplier, i.e. value of .1 would mean 10%
@export var is_percentage: bool

func _get_description() -> String:
	return \
		description % (\
			(str(int(heal * 100)) + " percent of damage as") if is_percentage \
			else str( int(heal) )
		)

func apply_heal(a: Attack)->void:
	@warning_ignore("narrowing_conversion")
	var val: int = (heal * a.applied_damage) if is_percentage else heal
	target_unit.heal(val)

func vampiric_heal(attack: Attack) ->void:
	if attack.attacker == target_unit:
		self.call_deferred(&"apply_heal", attack)

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	heal = params[0]
	is_percentage = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.heal, other_effect.is_percentage]
	return [heal, is_percentage]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.attack_resolved] = vampiric_heal
	
