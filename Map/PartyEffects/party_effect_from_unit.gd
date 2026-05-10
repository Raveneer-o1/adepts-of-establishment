@abstract
class_name PartyEffectFromUnit
extends PartyEffectFromSource

## Base class for party-wide effects originating from specific units.
##
## Examples include hero abilities affecting the entire party.
## Effects deactivate when the source unit dies and reactivate upon resurrection.
## [br][br]
## [b]Note:[/b] When deriving from this class, avoid direct signal connections.
## Use [member effect_mapping] instead, as this class handles signal processing
## with built-in validation.

var source_unit: UnitData:
	get: return source if source is UnitData else null
	set(value): source = value

func _connect_to_source(_source: Object) -> void:
	if not _source: return
	if _source is not UnitData: return
	(_source as UnitData).unit_moved.connect(queue_free)

func _disconnect_from_source(_source: Object) -> void:
	if not _source: return
	if _source is not UnitData: return
	if (_source as UnitData).unit_moved.is_connected(queue_free):
		(_source as UnitData).unit_moved.disconnect(queue_free)

func _validate_call() -> bool:
	if source_unit.is_dead: return false
	
	if source_unit.party != party_parameters.this_party:
		return false
	
	# NOTE: maybe should add another layer of validation on the unit side
	return true
