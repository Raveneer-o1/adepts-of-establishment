@abstract
class_name MapUnitEffect
extends Node

## Represents an effect applied to a unit on the map
##
## This node must be attached as a direct child of [UnitData] node.

@onready var unit: UnitData = get_parent()

## Initializes and activates the effect.
@abstract func apply() -> void
	# To modify the entire party, create a PartyEffectFromUnit node
	# referencing this unit rather than connecting this effect to party signals.

func _remove() -> void:
	# Clean up all the objects created and disconnect all connections.
	# This is important: connections must be disconnected because this method
	# can be called even if the effect is not queued for deletion
	# (e.g., when moving the unit)
	pass

## Removes the effect entirely, freeing the node and performing cleanup.
func remove() -> void:
	queue_free()
	_remove()

## Reinitializes the effect when the unit changes location (party or building).
func on_unit_move() -> void:
	# Override if the effect requires custom reconfiguration after unit movement.
	_remove()
	apply()

func _ready() -> void:
	apply.call_deferred()
