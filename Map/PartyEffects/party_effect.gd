@abstract
class_name PartyEffect
extends Node

var effect_name: String
@export var party_parameters: PartyParameters
@export_multiline var description: String

@abstract func _apply_effect(...args: Array) -> void

func apply_effect(...args: Array) -> void:
	_initialize.call_deferred.callv(args)

func _initialize(...args: Array) -> void:
	party_parameters = (get_parent() as MapParty).parameters
	_apply_effect.callv(args)

func remove_effect() -> void:
	queue_free()
