class_name PartyParameters
extends Node

@onready var this_party: MapParty = $".."

@export var units: Array[UnitData]:
	get:
		return this_party.units


## Accumulated value for data exchange between signal emission and receiver callbacks.
## When a request signal is emitted (e.g., [signal movement_multiplier_requested]),
## external listeners can modify this value.[br][br]
##
## This value's type indicates whether it is currently in use. Defaults to [b]null[/b] type
## with value [code]null[/code]. Listeners must set it to an appropriate type when
## modifying results. After signal processing and result calculation, this field is
## automatically reset to [code]null[/code]. [br][br]
##
## Usage Example:
## [codeblock]
## # Type ambiguity can cause effects to fail:
## # var fixed_cost = 1  # May cause incorrect behavior (e.g. being inferred as float during division)
## # var fixed_cost := 1       # Works correctly (explicitly int)
## # var fixed_cost: int = 1   # Even better for readability
## const fixed_cost = 1        # Constants have explicit types - this works correctly
##
## func apply_effect() -> void:
##     # Effect: fixed cost for water tiles
##     party_parameters.movement_cost_requested.connect(modify_cost)
##     
##     # Effect: double movement cost for all tiles
##     party_parameters.movement_multiplier_requested.connect(modify_multiplier)
##     
##     # Combined effect: double all costs, except water which costs 1
##
## func modify_cost(data: TileData) -> void:
##     if data.get_custom_data("tile_type") == &"water":
##         party_parameters.accumulated_value = fixed_cost
##
## func modify_multiplier() -> void:
##     party_parameters.accumulated_value = 2
## [/codeblock]
## [br]
## The value can be manipulated multiple times, enabling stacking:
## [codeblock]
## const fixed_cost = 1
##
## func apply_effect() -> void:
##     # Stackable effect: multiplicatively doubles movement cost
##     party_parameters.movement_multiplier_requested.connect(modify_multiplier)
##
## func modify_multiplier() -> void:
##     if typeof(party_parameters.accumulated_value) == TYPE_INT:
##         # Multiply existing value for stacking
##         party_parameters.accumulated_value *= 2
##     else:
##         # Initialize on first call
##         party_parameters.accumulated_value = 2
## [/codeblock]
var accumulated_value: Variant = null

## Emitted when unit data is requested via [method get_unit_data].
## External systems should listen for this signal and set [member accumulated_value].
signal unit_data_requested
## Emitted when movement multiplier is requested via [method get_movement_multiplier].
## External systems should listen for this signal and set [member accumulated_value].
signal movement_multiplier_requested
## Emitted when movement cost for a specific tile is requested.
## External systems should listen for this signal and set [member accumulated_value].
signal movement_cost_requested(tile_data: TileData)
## Emitted when maximum movement points value is requested.
## External systems should listen for this signal and set [member accumulated_value].
signal max_mp_requested(tile_data: TileData)

var _max_movement_points: int = 20
## This property automatically manages mp values by calling [method get_max_movement_points]
var max_movement_points: int:
	get: return get_max_movement_points()
	set(value): _max_movement_points = value
var movement_points: int = max_movement_points:
	get: return movement_points
	set(value): movement_points = clampi(value, 0, max_movement_points)

## Equivalent to just subtracting [param value] from [member movement_points]
## but checks if it is non-negative.
func subtract_mp(value: int) -> void:
	if value < 0: return
	movement_points -= value

func _get_accumulated_value(default: Variant) -> Variant:
	if accumulated_value == null: return default
	if typeof(accumulated_value) == typeof(default):
		var res: Variant = accumulated_value
		accumulated_value = null
		return res
	return default

func get_max_movement_points() -> int:
	max_mp_requested.emit()
	return _get_accumulated_value(_max_movement_points)

func get_unit_data() -> Array[UnitData]:
	unit_data_requested.emit()
	return _get_accumulated_value(units)

const DEFAULT_MOVEMENT_MULTIPLIER = 1
func get_movement_multiplier() -> int:
	movement_multiplier_requested.emit()
	return _get_accumulated_value(DEFAULT_MOVEMENT_MULTIPLIER)
