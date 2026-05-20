@abstract
class_name MapEvent
extends Node

func invoke() -> void:
	if _activated and one_time: return
	_invoke()
	_activated = true

@abstract func _invoke() -> void

## OR connection
@export var triggers: Array[MapTrigger]

@export var one_time := true

var _activated := false

# TODO: Reset the map_variables list at the start of each game/mission.
## Stores a list of in-game variables that can be modified by
## events and checked by both events and triggers. [br]
## [b]Note:[/b] Although events are attached to a specific [Map] node and only affect
## that map, these variables are global to the entire level. They are reset
## at the start of a new mission but persist across different maps within the same level.
static var map_variables: Dictionary[StringName, int]
var map: Map

func _initialize() -> void:
	pass

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map (Event)")
		queue_free()
		return
	_initialize.call_deferred()
	for trigger in triggers:
		trigger.triggered.connect(invoke)
