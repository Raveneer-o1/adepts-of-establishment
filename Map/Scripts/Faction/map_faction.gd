class_name MapFaction
extends Node

@export var base_faction: GlobalDefs.Faction
@export var controller: GlobalDefs.ControllerType

@onready var api: FactionAPI = $API
@onready var appearance: CanvasLayer = $Appearance
@onready var available_upgrades: EvolutionTreePopulator = $AvailableUpgrades
@onready var evolution_buildings: Node = $Appearance/EvolutionBuildings
@onready var resource_container: MapResourceContainer = $ResourceContainer

## Atlas coordinates of the tiles that represent this faction's land.
## If empty, this faction will never claim any land under any circumstances.
@export var tile_atlas_coords: Array[Vector2i]

@export var main_color: Color

## List of all units this faction can hire
@export var hiring_units: Array[StringName]

## Returns a list of all available evolutionary paths for the provided [param unit_name].
## This list is detemined by going through all [UnitEvolution] nodes attached
## as children to [member evolution_buildings].
func find_unit_evolution(unit_name: StringName) -> Array[StringName]:
	var res: Array[StringName] = []
	for c in evolution_buildings.get_children():
		if c is UnitEvolution:
			if c.evolving_from == unit_name:
				res.append(c.evolving_into)
	return res

## Returns a list of all [FactionUpgrade] nodes that currently have an 
## effect on the faction.
## Excludes [UnitEvolution] nodes by default. Set [param include_evolution_buildings]
## to [code]true[/code] to include evolution upgrades.
func get_all_upgrades(include_evolution_buildings: bool = false) -> Array[FactionUpgrade]:
	var res: Array[FactionUpgrade] = []
	for c in get_children() + appearance.get_children():
		if c is FactionUpgrade: res.append(c)
	if include_evolution_buildings:
		for c in $Appearance/EvolutionBuildings.get_children():
			if c is FactionUpgrade: res.append(c)
	return res


## [color=red][b]Never[/b] call this function directly.[/color]
## Use [method FactionAPI.research].
## [br][br]
## This method does not check if the provided [param upgrade]
## is valid for this faction.
func research(upgrade: FactionUpgrade) -> void:
	if not upgrade: return
	var parent_node := evolution_buildings if upgrade is UnitEvolution else self
	
	var prev_parent := upgrade.get_parent()
	
	if prev_parent:
		for child in upgrade.get_children():
			child.reparent(prev_parent)
		upgrade.reparent(parent_node)
	else: parent_node.add_child(upgrade)
	
	EventBus.capital_changed.emit(self)

## Selects an evolution path for [param unit] from [param options].
## This wrapper delegates to [method FactionAPI.choose_evolution].
## Can be asynchronous (use [code]await[/code]).
func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	if not options: return &""
	if options.size() == 1: return options[0]
	var chosen := await api.choose_evolution(unit, options)
	return chosen

## Levels up the provided [param unit]. If the evolution is impossible or
## [method choose_evolution] returns empty string (nothing chosen),
## simply calls [method UnitData.level_up].[br]
## Can be asynchronous (use [code]await[/code]).
func level_up_unit(unit: UnitData) -> void:
	if not unit: return
	var evolve_into: Array[StringName] = find_unit_evolution(unit.unit_name)
	if evolve_into:
		var chosen_path := await choose_evolution(unit, evolve_into)
		if chosen_path != &"":
			unit.evolve(chosen_path)
			return
	unit.level_up()

## Returns all [FactionUpgrade] nodes available for research.
## Excludes [UnitEvolution] nodes by default. Set [param include_evolution_buildings]
## to [code]true[/code] to include evolution upgrades.
func get_available_upgrades(include_evolution_buildings: bool = false) -> Array[FactionUpgrade]:
	var res: Array[FactionUpgrade] = []
	for c in available_upgrades.get_children():
		if c is FactionUpgrade: res.append(c)
	if include_evolution_buildings and available_upgrades.evolution_buildings:
		for c in available_upgrades.evolution_buildings.get_children():
			if c is FactionUpgrade: res.append(c)
	return res

## @experimental: returns [code]false[/code] for self-comparison, otherwise always returns [code]true[/code].
## Determines if this faction is hostile toward [param other_faction].
func is_enemy(other_faction: MapFaction) -> bool:
	if other_faction == self: return false
	# NOW: implement is_enemy()
	return true

func _ready() -> void:
	for upgrade in get_all_upgrades():
		upgrade.faction = self
