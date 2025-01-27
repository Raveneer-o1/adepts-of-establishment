extends Node
class_name AppliedEffect

@export var color_start: Color = Color.BURLYWOOD
@export var color_effect: Color = Color.YELLOW
@export var color_end: Color = Color.WHITE


## Base class for all unit effects.
## Designed to be modular and self-contained, with automatic cleanup once the effect ends.

const ICONS = preload("res://Arts/icons.png")

@export var effect_name: String = "Undefined"

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
## 10 - Fire.[br]
## 11 - Sword.[br]
## 12 - Eliptic/hexagonal magic.[br]
## 13 - Eye.[br]
## 14 - Bow.[br]
## 15 - Halo.[br]
## 16 - Skull.[br]
## 17 - Purple bottle.[br]
## 18 - Yellow bottle.[br]
## 19. - Blue bottle.[br]
@export var icon_index: int = 2

## If [code]true[/code], this effect will be lifted when unit is cured.
@export var negative_effect: bool = false

@export_multiline var description: String

## if [code]true[/code], the effect can be applied multiple times
@export var stackable: bool = false

## The unit to which this effect is attached.
var target_unit: Unit

func _get_description() -> String:
	return description

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
	target_unit.clean_effects()

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
	if (not stackable) and target_unit.parameters.have_effect(effect_name, self):
		queue_free()
		return
	_apply_effect(params)
	if icon_index >= 0:
		var image := ICONS.get_layer_data(icon_index)
		if not image:
			print_debug("Icon not found!")
			return
		target_unit.display_effect_icon(image, self)
