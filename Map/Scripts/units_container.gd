class_name UnitsContainer
extends Node

## Returns the number of leadership slots the specified [param unit] takes up.
static func get_unit_size(unit: UnitData) -> int:
	if not unit: return 0
	
	# large units take 3 slots in battle but only 2 leadership:
	# this is intentional
	return 2 if unit.large_unit else 1

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for ch in get_children():
			if ch is UnitData:
				res.append(ch)
		return res

# TODO: add a signal to gather unit data similar to how the party parameters work

## Returns if the specified [param unit] is stored inside this container.
func contains(unit: UnitData) -> bool:
	if not unit: return false
	return unit.container == self

## Returns number of leadership slots occupied in this container
func get_occupied_space() -> int:
	var res := 0
	for unit in units:
		res += get_unit_size(unit)
	return res
