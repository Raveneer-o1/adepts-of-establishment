@abstract
class_name PartyEffectFromItem
extends PartyEffect

## Base class for party-wide effects originating from specific items.

func _connect_to_item(item: MapItem) -> void:
	if not item: return
	item.item_moved.connect(queue_free)

func _disconnect_from_item(item: MapItem) -> void:
	if not item: return
	if item.item_moved.is_connected(queue_free):
		item.item_moved.disconnect(queue_free)

@export var source_item: MapItem:
	get: return source_item
	set(value):
		if value == source_item: return
		_disconnect_from_item(source_item)
		_connect_to_item(value)
		source_item = value

var effect_mapping: Dictionary[Signal, Callable]

func _execute_call(callable: Callable, args: Array) -> void:
	if args:
		callable = callable.bindv(args)
	callable.call()

func _validate_call() -> bool:
	if not is_instance_valid(source_item):
		source_item = null
		return false
	#if source_unit.is_dead: return false
	
	if source_item.item_owner != party_parameters.this_party:
		return false
	
	return true

func _call_if_valid(...args: Array) -> void:
	if not _validate_call(): return
	if not args:
		push_error("Empty argument list (%s)" % effect_name)
		return
	var s: Signal = args.pop_back()
	if not effect_mapping.has(s):
		push_error("Mapping does not exist (%s)" % effect_name)
		return
	_execute_call(effect_mapping[s], args)

func _initialize(...args: Array) -> void:
	super(args)
	if effect_mapping.is_empty():
		push_error(
			"The effect %s does not have a mapping. Did you connect manually?" % \
			effect_name
		)
		queue_free()
		return
	for s in effect_mapping:
		s.connect(_call_if_valid.bind(s))
