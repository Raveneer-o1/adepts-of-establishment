class_name MapFaction
extends Node

@export var base_faction: GlobalDefs.Faction
@export var controller: GlobalDefs.ControllerType
@onready var api: FactionAPI = $API
@onready var appearance: CanvasLayer = $Appearance
@onready var avaliable_upgrades: EvolutionTreePopulator = $AvaliableUpgrades
@onready var evolution_buildings: Node = $Appearance/EvolutionBuildings

## Atlas coordinates of the tiles that represent this faction's land
@export var tile_atlas_coords: Array[Vector2i]

## @experimental: will be replaced with a [Color] type variable
@export_range(0, 2) var main_color: int
#@export var main_color: Color

## List of all units this faction can hire
@export var hiring_units: Array[StringName]

func find_unit_evolution(unit_name: StringName) -> Array[StringName]:
	var res: Array[StringName] = []
	for c in evolution_buildings.get_children():
		if c is UnitEvolution:
			if c.evolving_from == unit_name:
				res.append(c.evolving_into)
	return res

func get_all_upgrades(include_evolution_buildings: bool = false) -> Array[FactionUpgrade]:
	var res: Array[FactionUpgrade] = []
	for c in get_children() + appearance.get_children():
		if c is FactionUpgrade: res.append(c)
	if include_evolution_buildings:
		for c in $Appearance/EvolutionBuildings.get_children():
			if c is FactionUpgrade: res.append(c)
	return res


func _research_evolution(building: UnitEvolution) -> void:
	if building.get_parent():
		evolution_buildings.add_child(building)
	else: evolution_buildings.add_child(building)

## This method does not check if the provided [param upgrade]
## is valid for this faction
func research(upgrade: FactionUpgrade) -> void:
	if not upgrade: return
	var parent_node := evolution_buildings if upgrade is UnitEvolution else self
	
	var prev_parent := upgrade.get_parent()
	
	if prev_parent:
		for child in upgrade.get_children():
			child.reparent(prev_parent)
		upgrade.reparent(parent_node)
	else: parent_node.add_child(upgrade)

func get_avaliable_upgrades(include_evolution_buildings: bool = false) -> Array[FactionUpgrade]:
	var res: Array[FactionUpgrade] = []
	for c in avaliable_upgrades.get_children():
		if c is FactionUpgrade: res.append(c)
	if include_evolution_buildings:
		for c in avaliable_upgrades.evolution_buildings.get_children():
			if c is FactionUpgrade: res.append(c)
	return res

func is_enemy(other_faction: MapFaction) -> bool:
	if other_faction == self: return false
	# TODO: implement is_enemy()
	return true

func _ready() -> void:
	for upgrade in get_all_upgrades():
		upgrade.faction = self
