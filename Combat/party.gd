class_name Party extends Node2D

const MAX_UNITS_NUMBER = 7

var other_party: Party
var main_system: CombatSystem

## Units are stored as one-dimentional array.
## Gameplay-wise units ate placed on a hexagonal grid and positions are counted top to bottom.
## Front line are units with even positions, back line - with odd positions.
## Because of hexagonal positioning, units in the front line have two units behind them
## and units in the back - two units in front of them
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
		units[i] = loaded_unit.instantiate()
		unit_positions[i].add_child(units[i])
		units[i].initialize_variables()
		units[i].party_position = i

func initialize_variables() -> void:
	for i in range(MAX_UNITS_NUMBER):
		units.append(null)
		unit_positions.append(null)
	
	for i in range(MAX_UNITS_NUMBER):
		unit_positions[i] = get_node("UnitPosition" + str(i)) as Node2D
		if unit_positions[i] == null:
			print_debug("UnitPosition" + str(i) + " not found!")
	

var unit_positions: Array[Node2D] = []

#func _ready() -> void:
	#initialize_variables()
