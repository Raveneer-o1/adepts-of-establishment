class_name MapTrigger
extends Node

## This signal is emitted when the trigger is activated.
signal triggered
var map: Map

func _initialize() -> void:
	pass

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map (Trigger)")
		queue_free()
		return
	_initialize.call_deferred()
