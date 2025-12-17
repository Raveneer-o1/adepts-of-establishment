class_name MapFaction
extends Node

@export var base_faction: GlobalDefs.Faction
@export var controller: GlobalDefs.ControllerType
@onready var api: FactionAPI = $API

## @experimantal: will be replaced with a [Color] type variable
@export_range(0, 2) var main_color: int
#@export var main_color: Color

func is_enemy(other_faction: MapFaction) -> bool:
	if other_faction == self: return false
	# TODO: implement is_enemy()
	return true
