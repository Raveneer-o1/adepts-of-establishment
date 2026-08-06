extends AppliedEffect

# Human friendly version of the name of the parameter to be modified by the effect
var _parameter: StringName

# Name of the parameter to be modified by the effect
var parameter: StringName:
	get:
		return PARAMETERS_NAMES[_parameter]

# Mapping of display names to their corresponding internal parameter names
const PARAMETERS_NAMES: Dictionary[StringName, StringName] = {
	"Health" = &"max_HP",
	"Attack" = &"base_damage",
	"Armor" = &"armor",
	"Evasion" = &"evasion",
	"Shielding chance" = &"shielding_chance",
}

## Number of turns the effect will last
@export var turns: int = 1

## Flat value to subtract from the parameter
@export var strength: int = 0

## Multiplier for the parameter
@export var multiplier: float = 1.0

var _applied_this_turn := true

func _get_description() -> String:
	if _parameter == &"Evasion": return "Evasion of this unit is decreased."
	var text_decrease: String = description
	
	if not is_equal_approx(multiplier, 1.0):
		text_decrease += " percent"
		
		if strength != 0:
			text_decrease += " plus %d"
			text_decrease = text_decrease % [_parameter, roundi((multiplier - 1) * 100), strength]
		else:
			text_decrease = text_decrease % [_parameter, roundi((multiplier - 1) * 100)]
	else:
		text_decrease = text_decrease % [_parameter, strength]
	
	return text_decrease

func count_turn(unit: Unit) -> void:
	if _applied_this_turn: return
	if unit == target_unit and turns > 0:
		turns -= 1
		if turns == 0:
			lift_effect()

func _drop_safeguard(_u: Unit = null) -> void:
	_applied_this_turn = false
	if EventBus.turn_started.is_connected(_drop_safeguard):
		EventBus.turn_started.disconnect(_drop_safeguard)

func apply_modifier() -> void:
	var param := parameter
	if param == &"evasion" or param == &"shielding_chance":
		target_unit.parameters.add_modifier(
			param,
			self,
			func (value: float) -> float:
				return value * multiplier - float(strength)
		)
	else:
		target_unit.parameters.add_modifier(
			param,
			self,
			func (value: int) -> int:
				return roundi(float(value) * multiplier - strength)
		)

func read_params(params: Variant) -> void:
	if params is not Dictionary:
		print_debug("Invalid parameter for 'temporary debuff' effect. \
				Expected Dictionary, found %s!" % type_string(typeof(params)))
		return
	
	var p : StringName = &"parameter"
	if params.has(p):
		if PARAMETERS_NAMES.has(params[p]):
			_parameter = params[p]
		else:
			print_debug("Unknown parameter '%s' for 'temporary debuff' effect." % params[p])
			return
	
	p = &"turns"
	if params.has(p):
		turns = params[p]
	
	p = &"strength"
	if params.has(p):
		strength = params[p]
	
	p = &"multiplier"
	if params.has(p):
		multiplier = params[p]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return {
			&"parameter": other_effect._parameter,
			&"turns": other_effect.turns,
			&"strength": other_effect.strength,
			&"multiplier": other_effect.multiplier,
		}
	return {
		&"parameter": _parameter,
		&"turns": turns,
		&"strength": strength,
		&"multiplier": multiplier,
	}

# Called when the effect is applied to a unit
func _apply_effect(params: Variant) -> void:
	# If the effect duration is zero, remove it immediately
	if turns == 0:
		queue_free()
		return
	
	apply_modifier()
	
	if turns > 0:
		_signal_function_pairs[EventBus.turn_ended] = count_turn
		
		# this is not relevant for the effect function,
		# so there's not need to use the dictionary
		EventBus.turn_started.connect(_drop_safeguard)
