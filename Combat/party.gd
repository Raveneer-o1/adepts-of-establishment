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

# References to other components in the system
var other_party: Party
var main_system: CombatSystem
var player: PlayerAPI

## Stores all units[br]
## NOTE: this should be a read-only member, however it's planned to have an option
## to move units during combat. For this reason this array stays modifiable
var units: Array[Unit] = []

var unit_spots: Array[UnitSpot] = []

func check_if_empty() -> bool:
	for unit in units:
		if unit != null and not unit.parameters.dead:
			return false
	return true

## Returns references to units at specified positions.
## - Empty spaces and dead units are skipped.
## - Out-of-bounds positions return null.
func get_units_at_positions(positions: Array[int], include_nulls: bool = true) -> Array[Unit]:
	var result: Array[Unit] = []
	for i in positions:
		if i >= 0 and i < units.size():
			if units[i] != null and not units[i].parameters.dead:
				result.append(units[i])
		else:
			if include_nulls:
				result.append(null)
	return result

func get_adjacent_units(pos: int) -> Array[Unit]:
	if pos < 0 or pos > MAX_UNITS_NUMBER:
		return []
	if units[pos] != null and units[pos].parameters.large_unit:
		pos = units[pos].party_position
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
		if units[i] != null and not units[i].parameters.dead:
			return false
	return true

## Filters units based on a custom function.
func get_units_custom(filter_func: Callable) -> Array[Unit]:
	var result: Array[Unit] = []
	for u in units:
		if filter_func.call(u) and not result.has(u):
			result.append(u)
	return result

## Places units based on a list of unit names.
func place_units(list: Array[String]) -> void:
	unit_spots.clear()
	for i in range(MAX_UNITS_NUMBER):
		unit_spots.append(main_system.UNIT_SPOT.instantiate())
		add_child(unit_spots[i])
		unit_spots[i].position = get_unit_position(i)
		unit_spots[i].system = main_system
		unit_spots[i].party_position = i
		unit_spots[i].party = self
	
	if list.size() > MAX_UNITS_NUMBER:
		print_debug("Unit list exceeds the maximum allowed number of units!")
		return
	
	var i := -1
	for s in list:
		i += 1
		if s.is_empty():
			continue
		if not main_system.loaded_units.has(s):
			print_debug(s + " is not loaded!")
			continue
		var loaded_unit: Resource = main_system.loaded_units[s]
		if units[i] != null:
			print_debug("Position " + str(i) + " is already occupied!")
			continue
		unit_spots[i].add_unit(loaded_unit)
		if units[i] == null:
			print_debug("Unit is not registered!")
			continue
		#units[i].party_position = i
		if units[i].parameters.large_unit:
			if i == 0 or i == MAX_UNITS_NUMBER - 1 or units[i - 1] != null:
				print_debug("Not enough space for large unit at position " + str(i) + "!")
				units[i].free()
				units[i] = null
				continue
			units[i + 1] = units[i]
			units[i - 1] = units[i]
			unit_spots[i].position = get_large_unit_position(i)
			unit_spots[i - 1].active = false
			unit_spots[i + 1].active = false

## Returns the coordinates tp place a large unit.
func get_large_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION + X_OFFSET / 2
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

## Returns the coordinates tp place a regular unit.
func get_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION if pos % 2 != 0 else X_START_POSITION + X_OFFSET
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

## Initializes unit storage variables.
func initialize_variables() -> void:
	for i in range(MAX_UNITS_NUMBER):
		units.append(null)

## Returns number of hexes between two positions
static func get_distance(pos1: int, pos2: int) -> int:
	return ceili(abs(pos1 - pos2) / 2.0)
