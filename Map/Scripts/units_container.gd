class_name UnitsContainer
extends Node

## Returns the number of leadership slots the specified [param unit] takes up.
static func get_unit_size(unit: UnitData) -> int:
	if not unit: return 0
	
	# large units take 3 slots in battle but only 2 leadership:
	# this is intentional
	return 2 if unit.large_unit else 1

## Raw data about units, before applying any effects.
var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for ch in get_children():
			if ch is UnitData:
				res.append(ch)
		return res

var _unit_list_copy: Array[UnitData] = []
signal __freing_units_finished
var __freing_units: bool = false:
	get: return __freing_units
	set(value):
		if not value: __freing_units_finished.emit()
		__freing_units = value

signal units_requested(prev_arr: Array[UnitData])


# NOTE: one object per frame probably is not necessary as the unit 
# list should only consist of not more than 10 objects
## Frees duplicate objects created by [method get_unit_list_copy].
## Processes one object per frame to avoid performance spikes.
## Use [code]await[/code] if you need to wait for complete removal.
func free_units_list() -> void:
	var unit_list_copy_for_freeing := _unit_list_copy
	_unit_list_copy = []
	if __freing_units: await __freing_units_finished
	__freing_units = true
	for data in unit_list_copy_for_freeing:
		await get_tree().process_frame
		data.queue_free()
	__freing_units = false

## Returns a deep copy of the [member units] array.
## The duplicated objects become orphans but do not require manual freeing -
## previously generated copies are automatically cleaned up when this method is called.
func get_unit_list_copy() -> Array[UnitData]:
	free_units_list()
	var units_original := units
	for data in units_original:
		var dupl := data.duplicate()
		dupl.original = data
		_unit_list_copy.append(dupl)
	return _unit_list_copy

## Returns the actual unit data list, after applying all effects.
func get_units_data() -> Array[UnitData]:
	var _units := get_unit_list_copy()
	units_requested.emit(_units)
	return _units


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
