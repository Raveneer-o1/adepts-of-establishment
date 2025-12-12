class_name MapFaction
extends Node

@export var base_faction: GlobalDefs.Faction
@export var controller: GlobalDefs.ControllerType
@onready var api: FactionAPI = $API

func is_enemy(other_faction: MapFaction) -> bool:
	if other_faction == self: return false
	# TODO: implement is_enemy()
	return true
