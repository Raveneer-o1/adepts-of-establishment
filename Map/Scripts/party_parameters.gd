class_name PartyParameters
extends Node

@onready var map_party: MapParty = $".."

@export var units: Array[UnitData]:
	get:
		return map_party.units
