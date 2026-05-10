@abstract
class_name PartyEffect
extends Node

var effect_name: String
@export var party_parameters: PartyParameters
@export_multiline var description: String

@abstract func _apply_effect(...args: Array) -> void

enum StatBuff{
	health,
	damage,
	armor,
	evasion,
	shielding_chance,
}

## Applies the effect. Initialization happens in deferred mode, so parameters can be set
## after calling this method; they will be read when the current call chain is complete.
func apply_effect(...args: Array) -> void:
	_initialize.call_deferred.callv(args)

func _initialize(...args: Array) -> void:
	if args.size() == 1 and args[0] is Array:
		args = args[0]
	
	party_parameters = (get_parent() as MapParty).parameters
	_apply_effect.callv(args)

func remove_effect() -> void:
	queue_free()
