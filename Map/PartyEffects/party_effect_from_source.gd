@abstract
class_name PartyEffectFromSource
extends PartyEffect

## Base class for party-wide effects originating from specific source.
##
## Examples include hero abilities affecting the entire party and effects
## from specific items equipped by the hero.
## Effects deactivate when the source become unavailable and reactivate
## upon regaining access to it.
## [br][br]
## [b]Note:[/b] When deriving from this class, avoid direct signal connections.
## Use [member effect_mapping] instead, as this class handles signal processing
## with built-in validation.


@abstract func _connect_to_source(_source: Object) -> void
# Implement this function to set up effect dependencies on the source object.
# This is typically used to connect to source signals like "on_change",
# for example to remove the effect when the source state changes in a way that
# makes the effect invalid (e.g., moving a unit to a different party).

@abstract func _disconnect_from_source(_source: Object) -> void
# Implement this function to clean up effect connections.
# This method should reverse the connections established in _connect_to_source().
# IMPORTANT: This method should only disconnect signals and references,
# not delete the effect itself (the source state should be considered valid).

@abstract func _validate_call() -> bool

@export var source: Node:
	get: return source
	set(value):
		if value == source: return
		_disconnect_from_source(source)
		_connect_to_source(value)
		source = value

## Mapping of signals to their corresponding callback functions.
## Use this dictionary instead of manually connecting signals.
var effect_mapping: Dictionary[Signal, Callable]

func _execute_call(callable: Callable, args: Array) -> void:
	if args:
		callable = callable.bindv(args)
	callable.call()

func __validate_call() -> bool:
	if not is_instance_valid(source):
		source = null
		return false
	return _validate_call()


func _call_if_valid(...args: Array) -> void:
	if not __validate_call(): return
	if not args:
		push_error("Empty argument list (%s)" % effect_name)
		return
	if args.back() is not Signal:
		push_error("Invalid argument list structure (%s)" % effect_name)
		return
	var s: Signal = args.pop_back()
	if not effect_mapping.has(s):
		push_error("Mapping does not exist (%s)" % effect_name)
		return
	_execute_call(effect_mapping[s], args)

func _initialize(...args: Array) -> void:
	super._initialize()
	if effect_mapping.is_empty():
		push_error(
			"The effect %s does not have a mapping. Did you connect manually?" % \
			effect_name
		)
		queue_free()
		return
	for s in effect_mapping:
		s.connect(_call_if_valid.bind(s))
