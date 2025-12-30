@abstract
class_name FactionUpgrade
extends Node

## A bulding, ability or other effect applied to the whole faction
##
## This nodes represent global progression (e.g., a building in the capital)

@export var upgrade_name: String = ""
@export_multiline var description: String

var faction: MapFaction
