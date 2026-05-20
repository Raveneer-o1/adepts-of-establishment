class_name MapTrigger
extends Node

## This signal is emitted when the trigger is activated.
signal triggered
var map: Map

## If [code]true[/code], this trigger will only activate once.
## After activation, the trigger is disabled by setting
## [member active] to [code]false[/code].
## The trigger can be manually re‑enabled by setting
## [member active] back to [code]true[/code],
## allowing it to trigger one additional time.
## [br][br]
## [b]Note:[/b] This property disables the trigger itself, while [member MapEvent.one_time]
## disables the associated event. Setting this value to [code]true[/code] does
## not prevent other triggers from invoking the same event.
@export var one_time := false
## Determines whether the trigger responds to activation attempts.
## [b]Note:[/b] When [code]false[/code], the trigger will not emit the
## [signal triggered] signal, but implementation‑specific logic may still run.
## It is recommended to add the following check at the beginning of 
## each trigger's validation method:
## [codeblock]
## if not active: return
## [/codeblock]
@export var active := true

func trigger() -> void:
	if not active: return
	if one_time: active = false
	triggered.emit()

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
