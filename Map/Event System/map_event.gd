@abstract
class_name MapEvent
extends Node

## A scripted event that can modify the map state or interact with the player.
##
## MapEvent objects are executed by calling [method invoke]. Each event maintains
## a list of [member triggers] that it listens to. The event is invoked whenever
## any one of its triggers activates (OR logic). To require that all triggers be
## activated before the event fires (AND logic), you must implement a custom
## trigger class that references the necessary triggers.

## The main entry point for the event. Validates the event's current state and
## delegates execution to an implementation‑specific method.
func invoke() -> void:
	if _activated and one_time: return
	_activated = true
	_invoke()

@abstract func _invoke() -> void

## List of triggers this event listens to
## (OR logic — event fires when any trigger activates).
## Do not modify this list directly at runtime. Use [method connect_to] and
## [method disconnect_from] to safely manage connections.
@export var triggers: Array[MapTrigger]

## If [code]true[/code], the event is deactivated after its first invocation.
## Any subsequent attmpts will be ignored.
@export var one_time := true

var _activated := false

var map: Map

func _initialize() -> void:
	pass

func connect_to(trigger: MapTrigger) -> void:
	if trigger in triggers: return
	triggers.append(trigger)
	if not trigger.triggered.is_connected(invoke):
		trigger.triggered.connect(invoke)

func disconnect_from(trigger: MapTrigger) -> void:
	if trigger not in triggers: return
	triggers.erase(trigger)
	if trigger.triggered.is_connected(invoke):
		trigger.triggered.disconnect(invoke)

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map (Event %s)" % name)
		queue_free()
		return
	_initialize.call_deferred()
	for trigger in triggers:
		trigger.triggered.connect(invoke)
