class_name Party
extends Node2D

## Main party node, serves as a container for all [Unit] nodes
##
## Units are stored as a one-dimensional array. ([member Party.units])[br]
## Units are placed on a hexagonal grid, and positions are counted from top to bottom.[br]
## - Frontline: Units with even positions.[br]
## - Backline: Units with odd positions.[br]
## Large units occupy three spaces (one on the current line and two adjacent spaces in another line).

# Constants to define the battle grid and unit placement.
# These constants are optimized for 7 units on the screen. 
# To scale the battle size, adjust these constants as necessary.
const MAX_UNITS_NUMBER = 7
const X_START_POSITION = 50.0
const Y_START_POSITION = 29.0
const X_OFFSET = 43.0
const Y_OFFSET = 27.0

@export var is_left: bool

# References to other components in the system
var other_party: Party
var main_system: CombatSystem
var player: PlayerAPI

var all_units: Array[Unit]

## Retuns an array of all units. This includes [code]null[/code] values for vacant spots. [br]
## [b]Note:[/b] this property does not return all units in the party, only mapping to
## positions in the party. For the former, use [member all_units]
var units: Array[Unit]:
	get:
		var res: Array[Unit] = []
		for spot in unit_spots:
			res.append(spot.unit)
		return res

var unit_spots: Array[UnitSpot] = []

## Returns the number of alive units in this party.
func get_units_number() -> int:
	var r := 0
	for s in unit_spots:
		if not s.active: continue
		if not s.unit: continue
		if s.unit.parameters.dead: continue
		r += 1
	return r

func check_if_empty() -> bool:
	for unit in units:
		if unit != null and not unit.parameters.dead:
			return false
	return true

func initialize() -> void:
	main_system = CombatSystem.get_combat_system()
	assert(main_system)
	other_party = main_system.right_party if is_left else main_system.left_party
	player = main_system.left_player if is_left else main_system.right_player

## Returns references to units at specified [params positions]. [br]
## - Empty spaces and dead units are skipped. [br]
## - Out-of-bounds positions return null if [param include_nulls] is [code]true[/code].
func get_units_at_positions(positions: Array[int], include_nulls: bool = true) -> Array[Unit]:
	var result: Array[Unit] = []
	for i in positions:
		if i < 0 or i >= units.size():
			if include_nulls: result.append(null)
			continue
		
		if not unit_spots[i].unit: continue
		if unit_spots[i].unit.parameters.dead: continue
		if unit_spots[i].unit in result: continue
		
		result.append(units[i])
	
	return result

func get_adjacent_units(pos: int) -> Array[Unit]:
	if pos < 0 or pos > MAX_UNITS_NUMBER:
		return []
	if unit_spots[pos].unit != null and unit_spots[pos].unit.parameters.large_unit:
		pos = unit_spots[pos].unit.party_position
		return get_units_at_positions([
			pos + 3,
			pos - 3,
			pos + 2,
			pos - 2,
		], false)
	return get_units_at_positions([
		pos + 1,
		pos - 1,
		pos + 2,
		pos - 2,
	], false)

## Checks if the frontline is empty.
func front_line_is_empty() -> bool:
	for i in range(0, MAX_UNITS_NUMBER, 2):
		if unit_spots[i].unit != null and not unit_spots[i].unit.parameters.dead:
			return false
	return true

## Filters units based on a custom function.
## Signature of the function is expected to be
## [codeblock](unit: Unit) -> bool[/codeblock]
func get_units_custom(filter_func: Callable) -> Array[Unit]:
	assert(filter_func.is_valid(), "Invalid callable")
	var result: Array[Unit] = []
	for u in units:
		if filter_func.call(u) and not result.has(u):
			result.append(u)
	return result

func _place_spots() -> void:
	for spot in unit_spots:
		if spot.unit: spot.unit.free()
		spot.free()
	unit_spots.clear()
	for i in range(MAX_UNITS_NUMBER):
		unit_spots.append(main_system.UNIT_SPOT.instantiate())
		add_child(unit_spots[i])
		unit_spots[i].position = get_unit_position(i)
		unit_spots[i].system = main_system
		unit_spots[i].party_position = i
		unit_spots[i].party = self

## Places units based on a list of unit names.
func place_units(list: Array[UnitData]) -> void:
	_place_spots()
	
	for unit_data: UnitData in list:
		#await get_tree().process_frame
		var i := unit_data.party_position
		if i < 0: continue
		if i >= MAX_UNITS_NUMBER:
			push_error("Incorrect placement (%d) of a unit '%s'" % [i, unit_data.unit_name])
			continue
		var path := unit_data.scene_path
		if path.is_empty(): continue
		if not main_system.loaded_units.has(path):
			push_error(unit_data.unit_name + " is not loaded!")
			continue
		if unit_spots[i].unit != null:
			push_error("Position %d is already occupied!" % i)
			continue
		var loaded_unit: Resource = main_system.loaded_units[path]
		var added_unit := unit_spots[i].add_unit(loaded_unit, unit_data)
		if not added_unit:
			push_error("Unit '%s' is not registered!" % unit_data.unit_name)
			continue
		all_units.append(added_unit)
		
		if not unit_spots[i].unit: continue
		if unit_spots[i].unit.parameters.large_unit:
			if i == 0 or i == MAX_UNITS_NUMBER - 1 or units[i - 1] != null:
				print_debug("Not enough space for large unit at position " + str(i) + "!")
				unit_spots[i].unit.free()
				unit_spots[i].unit = null
				continue
			unit_spots[i].position = get_large_unit_position(i)
			unit_spots[i - 1].is_active = false
			unit_spots[i - 1].unit = added_unit
			unit_spots[i + 1].is_active = false
			unit_spots[i + 1].unit = added_unit

## Returns the coordinates to place a large unit.
func get_large_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION + X_OFFSET / 2
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

## Returns the coordinates to place a regular unit.
func get_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION if pos % 2 != 0 else X_START_POSITION + X_OFFSET
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

## Returns number of hexes between two positions
static func get_distance(pos1: int, pos2: int) -> int:
	if pos1 == pos2: return 0
	return ceili(absf(pos1 - pos2) / 2.0)

static func is_front_line(pos: int) -> bool:
	return pos % 2 == 0
