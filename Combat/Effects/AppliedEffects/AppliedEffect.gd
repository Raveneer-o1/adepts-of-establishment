extends Node
class_name AppliedEffect

## Abstract class for unit effects like buffs or abilities.
## Designed to be modular and self-contained, with automatic cleanup when the effect ends.
##
## [AppliedEffect]s should be considered non-deterministic objects. 
## References can become invalid at any time. This even applies to new effects: 
## some effects (like cure) call [code]queue_free()[/code] 
## on themselves in [method initialize]. [br]
## [color=lightgreen]Note:[/color] [code]queue_free()[/code] schedules deletion at frame end,
## not immediately. This means: (i) reference validity need only be checked once per call chain,
## and (ii) use [method Object.is_queued_for_deletion] to verify pending deletion status. [br]
## This is also the reason why [code]free()[/code] should [b]not[/b] be used with this object:
## Some of the game logic verifies validity only once and would break if the object was
## suddenly freed. [br][br]
##
## This node attaches directly to a unit's [UnitParameters] node. Remove it using either: [br]
## - [method lift_effect] for normal removal [br]
## - [code]queue_free()[/code] to remove without triggering associated effects [br]

## If [code]false[/code], [method lift_effect] doesn't lift the effect.
## Note that you can still remove the effect with [code]queue_free()[/code]
@export var liftable: bool = true

## If [code]false[/code], [method silence_effect] doesn't block the effect.
## Note that you can still remove the effect with [code]queue_free()[/code]
## or lift it with [method lift_effect]
@export var silencable: bool = true

@export var color_start: Color = Color.BURLYWOOD
@export var color_effect: Color = Color.YELLOW
@export var color_end: Color = Color.WHITE

const ICONS := preload("res://Arts/icons.png")

@export var effect_name: String = "Undefined"

## Index of the effect's icon in the file [code]res://Arts/icons.png[/code].
## Shows on a unit that carries this effect, not on units affected by it.
## Value -1 disables icon.[br]
## 0 - Poison [br]
## 1 - Blood loss [br]
## 2 - Generic effect [br]
## 3 - Heart [br]
## 4 - Shield [br]
## 5 - Up [br]
## 6 - Down [br]
## 7 - Shield aura [br]
## 8 - Heart aura [br]
## 9 - Generic aura [br]
## 10 - Fire [br]
## 11 - Sword [br]
## 12 - Eliptic/hexagonal magic [br]
## 13 - Eye [br]
## 14 - Bow [br]
## 15 - Halo [br]
## 16 - Skull [br]
## 17 - Purple bottle [br]
## 18 - Yellow bottle [br]
## 19 - Blue bottle [br]
@export var icon_index: int = 2

## If [code]true[/code], this effect will be lifted when unit is cured.
@export var negative_effect: bool = false

@export_multiline var description: String

## if [code]true[/code], the effect can be applied multiple times
@export var stackable: bool = false

## When [member stackable] is [code]true[/code], defines the maximum stack count:[br]
## [b]-1[/b]: Unlimited stacks[br]
## [b]0[/b]: [color=yellow]Warning[/color]: Effect becomes impossible to apply[br]
## [b]>0[/b]: Exact maximum simultaneous instances[br]
@export var stack_limit: int = -1

## The unit to which this effect is attached.
var target_unit: Unit

## Stores pairs of signals and assosiated functions.
## Intended to be populated by the derived classes.
var _signal_function_pairs: Dictionary[Signal, Callable]

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

func _apply_effect(params: Variant) -> void:
	# Override this method in derived classes to implement the effect's application logic.
	# Do not connect to signals manually - this is handled automatically via the 
	# _signal_function_pairs dictionary.
	
	# For one-time effects, remove them here using queue_free().
	# See the "Cure" effect implementation as a reference example.
	pass

func _remove_effect() -> void:
	# Override this method in derived classes to define custom behavior when the effect is removed.
	# Note: This method is only called when the effect is explicitly lifted using lift_effect().
	# It cannot catch queue_free() calls and should not be used for memory management purposes.
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
	target_unit.clean_effects()
	queue_free()

var silenced_turns: int = -1

func silence_count() -> void:
	silenced_turns -= 1
	if silenced_turns <= 0:
		restore_effect()

func check_silence_countdown(unit: Unit) -> void:
	if unit == target_unit:
		silence_count()

var silenced: bool = false

## Moves the node to a [kbd]SilencedEffects[/kbd] container and deactivates it by 
## disconnecting all signals.
## Use [method restore_effect] to restore the effect to its functional state. [br]
## [param time] specifies automatic restoration after the given number of turns
## (-1 for manual restoration only). [br]
## If [param is_round] is [code]true[/code], [param time] is interpreted as round count 
## instead of turns. [br]
## Notes: [br]
## - The [kbd]SilencedEffects[/kbd] container must be a sibling of this effect node [br]
## - If [member silencable] is [code]false[/code], this method does nothing and returns immediately
## - if [param time] is set to a negative value, [param is_round] is ignored
func silence_effect(time: int = -1, is_round: bool = false) -> void:
	if not silencable:
		return
	if silenced: return
	
	var silenced_storage := get_parent().find_child("SilencedEffects", false)
	if not silenced_storage:
		print_debug("Unable to find 'SilencedEffects' node!")
		return
	
	silenced = true
	
	get_parent().remove_child(self)
	silenced_storage.add_child(self)
	
	# connect timeout clock if necessary
	if time >= 0:
		silenced_turns = time
		if round: EventBus.round_ended.connect(silence_count)
		else: EventBus.turn_ended.connect(check_silence_countdown)
	
	# disconnect callables
	for signal_in_pairs: Signal in _signal_function_pairs:
		if signal_in_pairs.is_connected(_signal_function_pairs[signal_in_pairs]):
			signal_in_pairs.disconnect(_signal_function_pairs[signal_in_pairs])

## Restores the effect to its functional state by reconnecting signals and moving
## it back to its original parent.
## Safe to call multiple times - subsequent calls will have no additional effect.
func restore_effect() -> void:
	if not silenced: return
	var silenced_effects_node : Node = get_parent()
	if not silenced_effects_node or \
		not silenced_effects_node.get_parent() is UnitParameters:
			push_error("Trying to restore effect that doesn't have a UnitParameters node as a grandparent!")
			return
	if EventBus.round_ended.is_connected(check_silence_countdown):
		EventBus.round_ended.disconnect(check_silence_countdown)
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
	
	if not stackable:
		# second agrument excluds this instance which is being added
		if target_unit.parameters.have_effect(effect_name, self):
			queue_free()
			return
	
	else:
		# second agrument excluds this instance which is being added
		var effect_count: int = target_unit.parameters.count_effects(effect_name, self)
		
		# Remove this instance if stack limit reached
		if stack_limit >= 0 and effect_count >= stack_limit:
			queue_free()
			return
	
	_apply_effect(params)
	connect_callables()
	if icon_index >= 0:
		var image: Image = ICONS.get_layer_data(icon_index)
		if image == null:
			print_debug("Icon not found!")
			return
		target_unit.display_effect_icon(image, self)
