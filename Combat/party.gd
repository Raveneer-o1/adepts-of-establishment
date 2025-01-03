class_name Party
extends Node2D

## Constants to define the battle grid and unit placement.
## These constants are optimized for 7 units on the screen. 
## To scale the battle size, adjust these constants as necessary.
const MAX_UNITS_NUMBER = 7
const X_START_POSITION = 50.0
const Y_START_POSITION = 50.0
const X_OFFSET = 40.0
const Y_OFFSET = 25.0

## References to other components in the system
var other_party: Party
var main_system: CombatSystem

## Units are stored as a one-dimensional array.
## Units are placed on a hexagonal grid, and positions are counted from top to bottom.
## - Frontline: Units with even positions.
## - Backline: Units with odd positions.
## Large units occupy three spaces (one on the current line and two adjacent spaces in another line).
var units: Array[Unit] = []

## Returns references to units at specified positions.
## - Empty spaces and dead units are skipped.
## - Out-of-bounds positions return null.
func get_units_at_positions(positions: Array[int]) -> Array[Unit]:
	var result: Array[Unit] = []
	for i in positions:
		if i >= 0 and i < units.size():
			if units[i] != null and not units[i].parameters.dead:
				result.append(units[i])
		else:
			result.append(null)
	return result

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
		units[i] = loaded_unit.instantiate()
		add_child(units[i])
		units[i].initialize_variables()
		units[i].party_position = i
		if units[i].parameters.large_unit:
			if i == 0 or i == MAX_UNITS_NUMBER - 1 or units[i - 1] != null:
				print_debug("Not enough space for large unit at position " + str(i) + "!")
				units[i].free()
				units[i] = null
				continue
			units[i + 1] = units[i]
			units[i - 1] = units[i]
			units[i].position = get_large_unit_position(i)
		else:
			units[i].position = get_unit_position(i)

## Returns the coordinates for a large unit.
func get_large_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION + X_OFFSET / 2
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

## Returns the coordinates for a regular unit.
func get_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION if pos % 2 != 0 else X_START_POSITION + X_OFFSET
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

## Initializes unit storage variables.
func initialize_variables() -> void:
	for i in range(MAX_UNITS_NUMBER):
		units.append(null)
