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
## List of all heroes this faction can hire.
## Standard faction-specific heroes are added at the start of the game.
@export var hiring_heroes: Array[StringName]

@export_group("Starting resources")
@export var starting_gold := 0
@export var starting_stone := 0
@export var starting_mana := 0

var capital: MapCapital
var game: GameMap

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
	# TODO: implement is_enemy()
	return true

# WARNING: this hard-coded list mush be changed every time the heroes of any faction change.
# Alternitavly, we can implement another way to initializae available heroes.
# Maybe even scrap this function altogether and rely on hiring_heroes list.
func _append_heroes() -> void:
	match base_faction:
		GlobalDefs.Faction.Empire:
			if &"Thymaël Doux" not in hiring_heroes: 
				hiring_heroes.append(&"Thymaël Doux")
			if &"High mage" not in hiring_heroes: 
				hiring_heroes.append(&"High mage")
			if &"Cartographer" not in hiring_heroes: 
				hiring_heroes.append(&"Cartographer")
			if &"Knight Champion" not in hiring_heroes: 
				hiring_heroes.append(&"Knight Champion")
			if &"Sir Roland" not in hiring_heroes: 
				hiring_heroes.append(&"Sir Roland")
		GlobalDefs.Faction.Necropolis:
			if &"Bone collector" not in hiring_heroes: 
				hiring_heroes.append(&"Bone collector")
			if &"Dame The Seraph" not in hiring_heroes: 
				hiring_heroes.append(&"Dame The Seraph")
			if &"Grave whisperer" not in hiring_heroes: 
				hiring_heroes.append(&"Grave whisperer")
			if &"Margrave Solreth" not in hiring_heroes: 
				hiring_heroes.append(&"Margrave Solreth")
			if &"Virion the Bonebinder" not in hiring_heroes: 
				hiring_heroes.append(&"Virion the Bonebinder")

## Returns all parties owned by this faction.
## If [param only_active_map] is [code]false[/code], searches across all maps in the game.
## Otherwise, only the currently active map is considered.
func get_available_parties(only_active_map := false) -> Array[MapParty]:
	var res: Array[MapParty] = []
	for map: Map in ([game.current_map] if only_active_map else game.get_all_maps()):
		for party in map.get_all_parties():
			if party.object_owner == self: res.append(party)
	return res


func _ready() -> void:
	_find_game()
	for upgrade in get_all_upgrades():
		upgrade.faction = self
	_append_heroes()
	resource_container.receive_gold(starting_gold)
	resource_container.receive_stone(starting_stone)
	resource_container.receive_mana(starting_mana)

func _find_game() -> void:
	var p := get_parent()
	while p:
		if p is GameMap: game = p; return
		p = p.get_parent()
	push_error("Unable to find GameMap node")
