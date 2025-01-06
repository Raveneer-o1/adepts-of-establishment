extends Node
class_name AppliedEffect

## Base class for all unit effects.
## Designed to be modular and self-contained, with automatic cleanup once the effect ends.

## If [code]true[/code], this effect will be lifted when unit is cured.
@export var negative_effect: bool = false

## The unit to which this effect is attached.
var target_unit: Unit

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to define the effect's behavior when applied.
	pass

## Call to manually remove the effect (e.g., if cured or expired).
## Emits [member EventBus.effect_lifted]. [br]
## If you need to remove effect without emitting signal (e.g. when a unit dies),
## just remove the node with [code]queue_free()[/code].
func lift_effect() -> void:
	print_debug("Effect on %s is being lifted." % target_unit.unit_name)
	EventBus.effect_lifted.emit(self)
	_remove_effect()
	queue_free()

## Internal cleanup when the effect is removed.
func _remove_effect() -> void:
	pass

# Called when this node is added to a unit. Automatically applies the effect.
func initialize(params: Variant = null) -> void:
	target_unit = (get_parent() as UnitParameters).parent_unit
	if target_unit == null:
		print_debug("Effect is missing a target unit!")
		queue_free()
		return
	_apply_effect(params)
