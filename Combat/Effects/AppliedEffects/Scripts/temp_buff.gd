extends AppliedEffect

# Human friendly version of the name of the parameter to be modified by the effect
var _parameter: StringName

# Name of the parameter to be modified by the effect
var parameter: StringName:
	get:
		return PARAMETERS_NAMES[_parameter]

# Mapping of display names to their corresponding internal parameter names
const PARAMETERS_NAMES = {
	"Health" = "max_HP",
	"Attack" = "base_damage",
	"Armor" = "armor",
}

# Number of turns the effect will last
var turns: int = 1

# Flat value to add to the parameter (optional)
var strength: int = 0

# Multiplier for the parameter (optional)
var multiplier: float = 1.0

# Constructs a description string for the effect, including parameter modifications
func _get_description() -> String:
	var text_increase: String = description  # Base description text
	
	if multiplier > 1.0:
		# If the multiplier is greater than 1, include percentage increase
		text_increase += " percent"
		
		# Include flat increase if applicable
		if strength != 0:
			text_increase += " plus %d"
			text_increase = text_increase % [_parameter, round((multiplier - 1) * 100), strength]
		else:
			text_increase = text_increase % [_parameter, round((multiplier - 1) * 100)]
	else:
		# If no multiplier, only include flat increase
		text_increase = text_increase % [_parameter, strength]
	
	return text_increase

# Reduces the number of remaining turns and removes the effect when expired
func count_turn(unit: Unit) -> void:
	if unit == target_unit:
		if turns <= 0:
			lift_effect()
		turns -= 1

# Applies the parameter modifier to the target unit
func apply_modifier() -> void:
	target_unit.parameters.add_modifier(
			parameter,
			self,
			func (value: int) -> int:
				return roundf(float(value) * multiplier + strength)
	)

# Attempts to initialize the effect's parameters from a dictionary
# returns if initialization was succsessful
func try_init_params(params: Variant) -> bool:
	if params is Dictionary:
		# Check and initialize "parameter" if present
		var p : StringName = "parameter"
		if params.has(p):
			if PARAMETERS_NAMES.has(params[p]):
				_parameter = params[p]
			else:
				# Log a debug message if an unknown parameter is provided
				print_debug("Unknown parameter '%s' for 'temporary buff' effect." % params[p])
				return false
		
		# Check and initialize "turns" if present
		p = "turns"
		if params.has(p):
			turns = params[p]
		
		# Check and initialize "strength" if present
		p = "strength"
		if params.has(p):
			strength = params[p]
		
		# Check and initialize "multiplier" if present
		p = "multiplier"
		if params.has(p):
			multiplier = params[p]
		
		
	else:
		# Log a debug message if the input is not a Dictionary
		print_debug("Invalid parameter for 'temporary buff' effect. \
				Expected Dictionary, found %s!" % type_string(typeof(params)))
		return false
	
	return true

# Called when the effect is applied to a unit
func _apply_effect(params: Variant) -> void:
	# Attempt to initialize parameters; remove effect if initialization fails
	if not try_init_params(params):
		queue_free()
		return
	
	# If the effect duration is zero or less, remove it immediately
	if turns <= 0:
		queue_free()
		return
	
	# Apply the parameter modifier to the target unit
	apply_modifier()
	
	# Connect to the event bus to handle turn-based decrement of the effect duration
	EventBus.turn_started.connect(count_turn)
