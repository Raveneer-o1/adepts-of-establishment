class_name MapFaction
extends Node

@export var base_faction: GlobalDefs.Faction
@export var controller: GlobalDefs.ControllerType
@onready var api: FactionAPI = $API

## Atlas coordinates of the tiles that represent this faction's land
@export var tile_atlas_coords: Array[Vector2i]

## @experimental: will be replaced with a [Color] type variable
@export_range(0, 2) var main_color: int
#@export var main_color: Color

## List of all units this faction can hire
@export var hiring_units: Array[StringName]

func find_unit_evolution(unit_name: StringName) -> Array[StringName]:
	var res: Array[StringName] = []
	for c in get_all_upgrades():
		if c is UnitEvolution:
			if c.evolving_from == unit_name:
				res.append(c.evolving_into)
	return res

func get_all_upgrades() -> Array[FactionUpgrade]:
	var res: Array[FactionUpgrade] = []
	for c in get_children():
		if c is FactionUpgrade: res.append(c)
	return res

func is_enemy(other_faction: MapFaction) -> bool:
	if other_faction == self: return false
	# TODO: implement is_enemy()
	return true
