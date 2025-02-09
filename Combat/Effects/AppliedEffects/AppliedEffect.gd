extends Node
class_name AppliedEffect

## Abstract class for effects, applied to a unit, such as buffs or abilities.
## Designed to be modular and self-contained, with automatic cleanup once the effect ends.

## If [code]false[/code], [method lift_effect] doesn't lift the effect.
## Note that you can still remove the effect with [code]queue_free()[/code]
@export var liftable: bool = true

## If [code]false[/code], [method silence_effect] doesn't block the effect.
## Note that you can still remove the effect with [code]queue_free()[/code]
@export var silencable: bool = true

@export var color_start: Color = Color.BURLYWOOD
@export var color_effect: Color = Color.YELLOW
@export var color_end: Color = Color.WHITE


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

## When [member stackable] is [code]true[/code], defines the maximum stack count:[br]
## - [b]-1[/b]: Unlimited stacks[br]
## - [b]0[/b]: [color=red]WARNING[/color] Effect becomes impossible to apply[br]
## - [b]>0[/b]: Exact maximum simultaneous instances[br]
@export var stack_limit: int = -1

## The unit to which this effect is attached.
var target_unit: Unit

## Stores pairs of signals an assosiated functions. Intended to be overridden is the derived classes
var _signal_function_pairs: Dictionary

func _get_description() -> String:
	return description

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to define the effect's behavior when applied.
	pass

## Internal cleanup when the effect is removed.
func _remove_effect() -> void:
	pass

## Call to manually remove the effect (e.g., if cured or expired).
## Emits [member EventBus.effect_lifted]. [br]
## If you need to remove effect without emitting the signal (e.g. when a unit dies),
## just remove the node with [code]queue_free()[/code].
func lift_effect() -> void:
	if not liftable:
		return
	
	EventBus.effect_lifted.emit(self)
	_remove_effect()
	queue_free()
	target_unit.clean_effects()

var silenced_turns: int = -1

func check_silence_countdown(unit: Unit) -> void:
	if unit == target_unit:
		if silenced_turns <= 0:
			restore_effect()
		silenced_turns -= 1

var silenced: bool = false

func silence_effect(turns: int = -1) -> void:
	if not silencable:
		return
	
	var silenced_storage := get_parent().find_child("SilencedEffects", false)
	if not silenced_storage:
		print_debug("Unable to find 'SilencedEffects' node!")
		return
	
	silenced = true
	
	get_parent().remove_child(self)
	silenced_storage.add_child(self)
	
	# connect timeout clock if necessary
	if turns >= 0:
		silenced_turns = turns
		EventBus.turn_ended.connect(check_silence_countdown)
	
	# disconnect callables
	for signal_in_pairs: Signal in _signal_function_pairs:
		if signal_in_pairs.is_connected(_signal_function_pairs[signal_in_pairs]):
			signal_in_pairs.disconnect(_signal_function_pairs[signal_in_pairs])
	

func restore_effect() -> void:
	var silenced_effects_node : Node = get_parent()
	silenced_effects_node.remove_child(self)
	silenced_effects_node.get_parent().add_child(self)
	
	connect_callables()
	silenced = false
	
	if EventBus.turn_ended.is_connected(check_silence_countdown):
		EventBus.turn_ended.disconnect(check_silence_countdown)

func connect_callables() -> void:
	for signal_in_pairs: Signal in _signal_function_pairs:
		signal_in_pairs.connect(_signal_function_pairs[signal_in_pairs])


## Called when this node is added to a unit. Automatically applies the effect.
func initialize(params: Variant = null) -> void:
	target_unit = (get_parent() as UnitParameters).parent_unit
	if target_unit == null:
		print_debug("Effect is missing a target unit!")
		queue_free()
		return
	
	# Non-stackable effect handling: Remove this instance if the target already has the effect
	if not stackable:
		# Check if effect exists on unit (excluding this instance which is being added)
		if target_unit.parameters.have_effect(effect_name, self):
			queue_free()
			return
		
	# Stackable effect handling: Enforce maximum instance limit
	else:
		# Count existing instances of this effect (excluding current pending instance)
		var effect_count: int = target_unit.parameters.count_effects(effect_name, self)
		
		# Remove this instance if stack limit reached
		if stack_limit != -1 and effect_count >= stack_limit:
			queue_free()
			return
	
	
	_apply_effect(params)
	connect_callables()
	if icon_index >= 0:
		var image := ICONS.get_layer_data(icon_index)
		if not image:
			print_debug("Icon not found!")
			return
		target_unit.display_effect_icon(image, self)
