@abstract
class_name FactionUpgrade
extends Node

## A bulding, ability or other effect applied the the whole faction
##
## This nodes represent global progression (e.g., a building in the capital)

@export var upgrade_name: String = ""

var faction: MapFaction
