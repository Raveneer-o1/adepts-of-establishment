class_name PartyParameters
extends Node

## When [code]true[/code], overrides [member GameSettings.safe_travel] with
## [member safe_travel] during pathfinding calculations.
@export var safe_travel_override: bool = false
## Determines whether the party avoids forced interactions.
## Has no effect if [member safe_travel_override] is set to [code]false[/code].
@export var safe_travel: bool = true

@onready var this_party: MapParty = $".."

## List of all units before applying any modifiers or effects.
## Avoid direct access to this array - use [method get_unit_data] for safe
## retrieval of processed unit information with all active effects applied.
var units: Array[UnitData]:
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
## External systems should listen for this signal and populate [member accumulated_value].
## [br][br]
## [color=red][b]Critical:[/b] Be careful with this signal.[/color][br]
## If [member accumulated_value] is already populated when your effect triggers,
## modify that list. Otherwise, you must create deep copy of [member units] list
## to avoid modifying original [UnitData] objects. Use [method get_unit_list_copy]
## to get properly copied list.
## [br][br]
## Expected [member accumulated_value] type: [code]Array[UnitData][/code]
signal unit_data_requested
## Emitted when movement multiplier is requested via [method get_movement_multiplier].
## External systems should listen for this signal and set [member accumulated_value].
## [br][br]
## Expected [member accumulated_value] type: [code]int[/code]
signal movement_multiplier_requested
## Emitted when movement cost for a specific tile is requested.
## External systems should listen for this signal and set [member accumulated_value].
## This value has a priority over movement multiplier: if this one is set,
## the latter will be ignored.
## [br][br]
## Expected [member accumulated_value] type: [code]int[/code]
signal movement_cost_requested(tile_data: TileData)
## Emitted when check if a specific tile is passable is requested.
## External systems should listen for this signal and set [member accumulated_value].
## [br][br]
## [b]Note:[/b] Tiles with negative [code]"traverse_cost"[/code] values bypass
## this check and are considered universally impassable.
## [br][br]
## Expected [member accumulated_value] type: [code]bool[/code]
signal movement_pass_check_requested(tile_data: TileData)
## Emitted when maximum movement points value is requested.
## External systems should listen for this signal and set [member accumulated_value].
## [br][br]
## Expected [member accumulated_value] type: [code]int[/code]
signal max_mp_requested()

var _max_movement_points: int = 20
## This property automatically manages mp values by calling [method get_max_movement_points]
var max_movement_points: int:
	get: return get_max_movement_points()
	set(value): _max_movement_points = value
var movement_points: int = max_movement_points:
	get: return movement_points
	set(value): movement_points = clampi(value, 0, max_movement_points)

var _unit_list_copy: Array[UnitData] = []
var _unit_list_copy_for_freeing: Array[UnitData] = []

## Frees duplicate objects created by [method get_unit_list_copy].
## Processes one object per frame to avoid performance spikes.
## Use [code]await[/code] if you need to wait for complete removal.
func free_units_list() -> void:
	_unit_list_copy_for_freeing = _unit_list_copy.duplicate()
	_unit_list_copy = []
	for data in _unit_list_copy_for_freeing:
		await get_tree().process_frame
		data.queue_free()

## Returns a deep copy of the [member units] array.
## The duplicated objects become orphans but do not require manual freeing -
## previously generated copies are automatically cleaned up when this method is called.
## [br][br]
## If you need to free the entire party scene, call [method free_units_list] manually.
func get_unit_list_copy() -> Array[UnitData]:
	free_units_list()
	var units_original := units
	for data in units_original:
		_unit_list_copy.append(data.duplicate())
	for i in range(units_original.size()):
		_unit_list_copy[i].original = units_original[i]
	return _unit_list_copy

## Equivalent to just subtracting [param value] from [member movement_points]
## but checks if it is non-negative.
func subtract_mp(value: int) -> void:
	if value < 0: return
	movement_points -= value

func get_movement_cost(tile_data: TileData) -> int:
	movement_cost_requested.emit(tile_data)
	var cost: int = _get_accumulated_value(-1)
	if cost >= 0: return cost
	return get_movement_multiplier() * tile_data.get_custom_data("traverse_cost")

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

## By default, all tiles are passable. Effects can connect to
## [signal movement_pass_check_requested] to block certain tile types
const DEFAULT_PASS = true
func check_pass(tile_data: TileData) -> bool:
	movement_pass_check_requested.emit(tile_data)
	return _get_accumulated_value(DEFAULT_PASS)

## Instantiates a [PartyEffect] scene from the specified [param path]
## and adds it to this party.
func apply_effect(path: String) -> PartyEffect:
	if not FileAccess.file_exists(path):
		push_error("file '%s' does not exist" % path)
		return null
	var res := load(path)
	if res is not PackedScene:
		push_error("'%s' is not a PackedScene!" % path)
		return null
	var node := (res as PackedScene).instantiate()
	if not node:
		push_error("Unable to instantiate '%s'" % path)
		return null
	if node is not PartyEffect:
		push_error("'%s' is not a PartyEffect node!" % path)
		node.free()
		return null
	this_party.add_child(node)
	return node

func _ready() -> void:
	EventBus.map_turn_started.connect(
		func (f: MapFaction) -> void:
			if f == this_party.faction:
				movement_points = max_movement_points
	)
