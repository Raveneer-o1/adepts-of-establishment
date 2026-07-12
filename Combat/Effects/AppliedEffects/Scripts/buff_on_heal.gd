extends AppliedEffect

@export_enum("Health", "Attack", "Armor") var parameter_to_buff: String
@export var buff_strength: int
@export var buff_multiplier: float
@export var buff_turns: int

@export var text_to_display: String = ""

func _get_description() -> String:
	return description % parameter_to_buff


# Name of the parameter to be modified by the effect
var parameter: StringName:
	get:
		return PARAMETERS_NAMES[parameter_to_buff]

# Mapping of display names to their corresponding internal parameter names
const PARAMETERS_NAMES = {
	"Health" = "max_HP",
	"Attack" = "base_damage",
	"Armor" = "armor",
}


func apply_buff(unit: Unit, heal: int, flags: Array[StringName]) -> void:
	if is_queued_for_deletion(): return
	if unit == target_unit: return
	if unit.parameters.dead: return
	
	var params: Dictionary = {
		"parameter": parameter,
		"turns": buff_turns,
		"multiplier": buff_multiplier,
		"strength": buff_strength
	}
	
	target_unit.parameters.apply_effect("temporary_buff", params)
	target_unit.system.display_text_near_unit( \
			target_unit,
			text_to_display,
			color_start
	)

func read_params(params: Variant) -> void:
	if params is not Dictionary:
		return
	parameter_to_buff = params.get("parameter_to_buff", "")
	buff_strength = params.get("buff_strength", 0)
	buff_multiplier = params.get("buff_multiplier", 1.0)
	buff_turns = params.get("buff_turns", 2)

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return {
			"parameter_to_buff" = other_effect.parameter_to_buff,
			"buff_strength" = other_effect.buff_strength,
			"buff_multiplier" = other_effect.buff_multiplier,
			"buff_turns" = other_effect.buff_turns,
		} 
	return {
		"parameter_to_buff" = parameter_to_buff,
		"buff_strength" = buff_strength,
		"buff_multiplier" = buff_multiplier,
		"buff_turns" = buff_turns,
	}

func _apply_effect(params: Variant) -> void:
	if parameter_to_buff == "":
		print_debug("Empty parameter value!")
		queue_free()
		return
	
	_signal_function_pairs[EventBus.unit_healed] = apply_buff
