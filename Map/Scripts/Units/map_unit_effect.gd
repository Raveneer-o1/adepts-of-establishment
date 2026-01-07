@abstract
class_name MapUnitEffect
extends Node

## Represents an effect applied to a unit on the map
##
## This node must be placed as a direct child of [UnitData] node.

@onready var unit: UnitData = get_parent()

@abstract func apply() -> void

func on_unit_move() -> void:
	pass

func _ready() -> void:
	pass
