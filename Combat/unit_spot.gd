extends Node2D
class_name UnitSpot

var _unit: Unit
var unit: Unit:
	get:
		if is_instance_valid(_unit):
			return _unit
		return null
	set(value):
		_unit = value
		#(get_child(0) as UnitArea).area_active = value != null

var system: CombatSystem

var party_position: int

var party: Party

func add_unit(loaded_unit: Resource) -> void:
	if unit != null:
		print_debug("Trying to add unit ot top of already existing one!")
		return
	unit = loaded_unit.instantiate()
	add_child(unit)
	unit.initialize_variables()
	unit.party_position = party_position
	party.units[party_position] = unit
	return

func click() -> void:
	system.clicked_unit(self)
