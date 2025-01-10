extends Node
class_name AppliedEffect

## Base class for all unit effects.
## Designed to be modular and self-contained, with automatic cleanup once the effect ends.

const ICONS = preload("res://Arts/icons.png")

## Index of the effect's icon in the file [code]res://Arts/icons.png[/code].
## Shows on a unit that carries this effect, not on units affected by it.
## Value -1 disables icon.[br]
## 0 - Poison.[br]
## 1 - Blood loss.[br]
## 2 - Generic effect.[br]
## 3 - Heart.[br]
## 4 - Shield.[br]
## 5 - Up.[br]
## 6 - Down.[br]
## 7 - Shield aura.[br]
## 8 - Heart aura.[br]
## 9 - Generic aura.[br]
## 11 - Fire.[br]
## 12 - Sword.[br]
## 13 - Eliptic/hexagonal magic.[br]
## 14 - Eye.[br]
## 15 - Bow.[br]
## 16 - Halo.[br]
## 17 - Skull.[br]
## 18 - Purple bottle.[br]
## 19 - Yellow bottle.[br]
## 20. - Blue bottle.[br]
@export var icon_index: int = 2

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
## If you need to remove effect without emitting the signal (e.g. when a unit dies),
## just remove the node with [code]queue_free()[/code].
func lift_effect() -> void:
	#print_debug("Effect on %s is being lifted." % target_unit.unit_name)
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
	if icon_index >= 0:
		var image := ICONS.get_layer_data(icon_index)
		if not image:
			print_debug("Icon not found!")
			return
		target_unit.display_effect_icon(image, self)
