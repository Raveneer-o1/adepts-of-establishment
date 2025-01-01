class_name Party extends Node2D

const MAX_UNITS_NUMBER = 7

var other_party: Party
var main_system: CombatSystem

var units: Array[Unit] = []

func place_units(list: Array[String]) -> void:
	if list.size() > MAX_UNITS_NUMBER:
		print_debug("list for placing units can't be bigger than maximum amount of units!")
		return
	var i := -1
	for s in list:
		i += 1
		if not main_system.loaded_units.has(s):
			print_debug(s + " is not loaded!")
			continue
		var loaded_unit: Resource = main_system.loaded_units[s]
		units[i] = loaded_unit.instantiate()
		unit_positions[i].add_child(units[i])
		units[i].initialize_variables()
		#self.add_child(units[i])
		#units[i].position = unit_positions[i].position

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
