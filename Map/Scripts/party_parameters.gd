class_name PartyParameters
extends Node

@onready var map_party: MapParty = $".."

@export var units: Array[UnitData]:
	get:
		return map_party.units

var max_movement_points: int = 20
var movement_points: int = max_movement_points
