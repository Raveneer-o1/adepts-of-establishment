extends Node
class_name AppliedEffect

## Base class for all unit effects.
## Designed to be modular and self-contained, with automatic cleanup once the effect ends.


# The unit to which this effect is attached.
@export var target_unit: Unit

# Called when the effect is applied to a unit.
func apply_effect() -> void:
	# Override this method in derived classes to define the effect's behavior when applied.
	pass

# Called when the effect is updated (e.g., at the start of a turn, end of a turn, etc.).
func update_effect() -> void:
	# Override this method in derived classes to define ongoing behavior.
	pass

# Called to manually remove the effect (e.g., if cured or expired).
func lift_effect() -> void:
	_on_effect_removed()

# Internal cleanup when the effect is removed.
func _on_effect_removed() -> void:
	print_debug("Effect on " + str(target_unit.unit_name) + " is being lifted.")
	queue_free()

# Called when this node is added to a unit. Automatically applies the effect.
func _ready() -> void:
	if target_unit == null:
		print_debug("Effect is missing a target unit!")
		queue_free()
		return
	apply_effect()
