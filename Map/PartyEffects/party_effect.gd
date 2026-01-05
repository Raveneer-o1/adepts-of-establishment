@abstract
class_name PartyEffect
extends Node

var effect_name: String
@export var party_parameters: PartyParameters
@abstract func _apply_effect() -> void

func _initialize() -> void:
	party_parameters = (get_parent() as MapParty).parameters
	_apply_effect()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialize.call_deferred()

func remove_effect() -> void:
	queue_free()
