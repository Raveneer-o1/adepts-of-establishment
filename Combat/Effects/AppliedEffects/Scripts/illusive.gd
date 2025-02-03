extends AppliedEffect

@export var evasion_buff: float = 0.0

@export_group("Other stat buff")
# Human friendly version of the name of the parameter to be modified by the effect
@export_enum("Health", "Attack", "Armor") var other_stat_buff: String = ""
@export var other_stat_buff_strength: int = 0
@export var other_stat_buff_multiplier: float = 1.0


func _get_description() -> String:
	var inceases_evsion: bool = not is_equal_approx(evasion_buff, 0.0)
	var increases_other_param: bool = other_stat_buff != ""
	
	if inceases_evsion != increases_other_param:
		if inceases_evsion:
			return description % "Evasion"
		return description % other_stat_buff
	return description % ("Evasion[/b] and [b]" + other_stat_buff)

func check_trigger(target: Unit, attack: Attack) -> void:
	if target != target_unit:
		return
	
	var inceases_evsion: bool = not is_equal_approx(evasion_buff, 0.000)
	var increases_other_param: bool = other_stat_buff != ""
	
	var evasion_buff_controlling_effect: AppliedEffect = self
	
	if increases_other_param:
		var params: Dictionary = {
			"parameter" = other_stat_buff,
			"turns" = -1, # -1 indicates unlimited duration
			"strength" = other_stat_buff_strength,
			"multiplier" = other_stat_buff_multiplier,
		}
		var buff: AppliedEffect = target_unit.parameters.apply_effect(
			"temporary_buff", 
			params, 
			true, # force stackability
			true # force to stack effect
		)
		if buff:
			evasion_buff_controlling_effect = buff
	# end of if statement
	
	if inceases_evsion:
		target_unit.parameters.add_modifier(
			&"evasion", 
			evasion_buff_controlling_effect, 
			func(ev: float) -> float: return ev + evasion_buff
		)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_missed] = check_trigger
