@abstract
class_name FactionController
extends Node

var api: FactionAPI

@abstract func _initialize() -> void
@abstract func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent := get_parent()
	if parent is not FactionAPI:
		push_error("FactionController object must be a child of FactionAPI node!")
		queue_free()
		return
	api = parent
	api.controller = self
	_initialize()
