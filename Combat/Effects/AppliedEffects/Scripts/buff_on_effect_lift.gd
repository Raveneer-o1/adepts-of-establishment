extends AppliedEffect
class_name BuffOnEffectLift

#"Health" = "max_HP",
#"Attack" = "base_damage",
#"Armor" = "armor",
@export_enum("Health", "Attack", "Armor") var parameter_to_buff: String
@export var buff_strength: int
@export var buff_multiplier: float
@export var buff_turns: int

@export var text_to_display: String = "Rallied!"

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


func apply_buff(effect: AppliedEffect) -> void:
	if effect is BuffOnEffectLift:
		return
	if effect.target_unit == null or \
			effect.target_unit.party != target_unit.party or \
			effect.target_unit.parameters.dead:
		return
	
	var params: Dictionary = {
		"parameter": parameter,
		"turns": buff_turns,
		"multiplier": buff_multiplier,
		"strength": buff_strength
	}
	
	effect.target_unit.parameters.apply_effect("temporary_buff", params)
	target_unit.system.display_text_near_unit( \
			effect.target_unit,
			text_to_display,
			color_start
	)

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	if parameter_to_buff == "":
		print_debug("Empty parameter value!")
		queue_free()
		return
	EventBus.effect_lifted.connect(apply_buff)
