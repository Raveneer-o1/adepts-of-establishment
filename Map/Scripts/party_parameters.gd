class_name PartyParameters
extends Node

@onready var map_party: MapParty = $".."

@export var units: Array[UnitData]:
	get:
		return map_party.units

var max_movement_points: int = 20
var movement_points: int = max_movement_points:
	get: return movement_points
	set(value): movement_points = clampi(value, 0, max_movement_points)

func get_movement_multiplier() -> int:
	return 1
