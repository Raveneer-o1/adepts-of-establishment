@abstract
class_name MapUnitEffect
extends Node

## Represents an effect applied to a unit on the map
##
## This node must be attached as a direct child of [UnitData] node.

const EFFECTS_DIRECTORY = "res://Map/Scripts/Units/MapEffects/"

## Applies serialized effects from the dictionary to the specified unit.
## Dictionary keys must be effect script paths (not scene paths), with values
## passed as arguments to each effect's [method apply].
## Returns the instantiated effect objects. [br][br]
## [b]Note:[/b] Script names without full paths are searched in
## [constant EFFECTS_DIRECTORY].
static func apply_serialized(serialized: Dictionary, unit_data: UnitData) -> Array[MapUnitEffect]:
	var res: Array[MapUnitEffect] = []
	for effect_path: String in serialized:
		if not effect_path.begins_with("res:"):
			effect_path = EFFECTS_DIRECTORY + effect_path
		if not FileAccess.file_exists(effect_path):
			push_error("File '%s' does not exist" % effect_path)
			continue
		var s: Script = load(effect_path)
		var node := Node.new()
		node.set_script(s)
		if node is not MapUnitEffect:
			push_error("Script is not a MapUnitEffect")
			node.queue_free()
			continue
		unit_data.add_child(node)
		(node as MapUnitEffect).apply(serialized[effect_path])
		res.append(node)
	return res

@onready var unit: UnitData = get_parent()

## Initializes and activates the effect.
@abstract func apply(...args: Array) -> void
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
