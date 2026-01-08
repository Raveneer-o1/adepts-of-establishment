@abstract
class_name PartyEffectFromUnit
extends PartyEffect

## Base class for party-wide effects originating from specific units.
##
## Examples include hero abilities affecting the entire party.
## Effects deactivate when the source unit dies and reactivate upon resurrection.
## [br][br]
## [b]Note:[/b] When deriving from this class, avoid direct signal connections.
## Use [member effect_mapping] instead, as this class handles signal processing
## with built-in validation.

@export var source_unit: UnitData

var effect_mapping: Dictionary[Signal, Callable]

func _execute_call(callable: Callable, args: Array) -> void:
	if args:
		callable = callable.bindv(args)
	callable.call()

func _validate_call() -> bool:
	if not is_instance_valid(source_unit):
		source_unit = null
		return false
	if source_unit.is_dead: return false
	
	if source_unit.party != party_parameters.this_party:
		return false
	
	# maybe should add another layer of validation on the unit side
	return true

func _call_if_valid(...args: Array) -> void:
	if not _validate_call(): return
	if not args:
		push_error("Empty argument list (%s)" % effect_name)
		return
	var s: Signal = args[-1]
	if not effect_mapping.has(s):
		push_error("Mapping does not exist (%s)" % effect_name)
		return
	args.remove_at(args.size() - 1)
	_execute_call(effect_mapping[s], args)

func _initialize() -> void:
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
