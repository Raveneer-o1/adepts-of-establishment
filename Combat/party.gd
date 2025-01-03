class_name Party extends Node2D

## Constants are tuned to fit 7 units on screen but the entire logic is built around the scalability.
## If you want to increase size of battle, the only thing to change in these constants
const MAX_UNITS_NUMBER = 7
const X_START_POSITION = 50.0
const Y_START_POSITION = 50.0
const X_OFFSET = 40.0
const Y_OFFSET = 25.0

var other_party: Party
var main_system: CombatSystem


## Units are stored as one-dimentional array.
## Gameplay-wise units ate placed on a hexagonal grid and positions are counted top to bottom.
## Front line are units with even positions, back line - with odd positions.
## Because of hexagonal positioning, units in the front line have two units behind them
## and units in the back - two units in front of them
## Large units take one space plus two adjacent places in another line (thus taking 3 spaces)
## in code this represents as three positions in a row
var units: Array[Unit] = []


## Returns references to Units at specified positions.
## Empty spaces and dead units are skipped. Positions out of bounds are returned as null
## For example: assuming there is only one unit in position 0,
##   get_units_at_positions([2, 0, -2]) returns [Object<Unit>(Node...), null]
##                                                        ↑               ↑
## empty space at pos 2 is skipped   unit at pos 0 is returned    pos -2 is out of bounds so it becomes null
func get_units_at_positions(positions: Array[int]) -> Array[Unit]:
	var result: Array[Unit] = []
	for i in positions:
		if i >= 0 and i < units.size():
			if units[i] != null and not units[i].parameters.dead:
				result.append(units[i])
		else:
			result.append(null)
	return result

func front_line_is_empty() -> bool:
	for i in range(0, MAX_UNITS_NUMBER, 2):
		if units[i] != null and not units[i].parameters.dead:
			return false
	return true

func get_units_custom(filter_func: Callable) -> Array[Unit]:
	var result: Array[Unit] = []
	for u in units:
		if filter_func.call(u):
			if not result.has(u):
				result.append(u)
	
	return result

func place_units(list: Array[String]) -> void:
	if list.size() > MAX_UNITS_NUMBER:
		print_debug("list for placing units can't be bigger than maximum amount of units!")
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
			print_debug("Unable to assign unit to position " + str(i))
			continue
		
		units[i] = loaded_unit.instantiate()
		add_child(units[i])
		units[i].initialize_variables()
		units[i].party_position = i
		
		if units[i].parameters.large_unit:
			if i == 0:
				print_debug("The first unit can't be large!")
				units[i].free()
				units[i] = null
				continue
			if i == MAX_UNITS_NUMBER - 1:
				print_debug("The last unit can't be large!")
				units[i].free()
				units[i] = null
				continue
			if units[i-1] != null:
				print_debug("Not enough space for large unit!")
				units[i].free()
				units[i] = null
				continue
			
			units[i + 1] = units[i]
			units[i - 1] = units[i]
			units[i].position = get_large_unit_position(i)
		else:
			units[i].position = get_unit_position(i)


func get_large_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION + X_OFFSET / 2
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

func get_unit_position(pos: int) -> Vector2:
	var x: float = X_START_POSITION if pos % 2 != 0 else X_START_POSITION + X_OFFSET
	var y: float = Y_START_POSITION + Y_OFFSET * pos
	return Vector2(x, y)

func initialize_variables() -> void:	
	for i in range(MAX_UNITS_NUMBER):
		units.append(null)

var unit_positions: Array[Node2D] = []
