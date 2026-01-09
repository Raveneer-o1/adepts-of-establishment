@abstract
class_name FactionUpgrade
extends Node

## A bulding, ability or other effect applied to the whole faction
##
## This nodes represent global progression (e.g., a building in the capital)

@export var gold_cost := 0
@export var stone_cost := 0
@export var mana_cost := 0

var cost: ResourceCost:
	get: return ResourceCost.new(gold_cost, stone_cost, mana_cost)

@export var upgrade_name: String = ""
@export_multiline var description: String

var faction: MapFaction

func can_be_researched() -> bool:
	var parent := get_parent()
	if parent is EvolutionTreePopulator:
		return true
	if parent is FactionUpgrade: return false
	if parent.name == EvolutionTreePopulator.EVOLUTION_BUILDINGS_NODE_NAME:
		return true
	return false
