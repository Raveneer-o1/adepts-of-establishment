class_name MapTrigger_OnDialogueChoice
extends MapTrigger

@export var dialogue_node_id := &""

## If [code]true[/code], this trigger skips debug validation.
## Its [member dialogue_node_id] will not be checked for duplicates with
## other triggers of the same type.
## Useful when multiple triggers must share the same dialogue ID. [br][br]
## This setting has no effect in release builds.
@export var suppress_error := false

func _check_id(id: StringName) -> void:
	if id == dialogue_node_id:
		trigger()

func _initialize() -> void:
	EventBus.dialogue_id_selected.connect(_check_id)
	
	if OS.is_debug_build(): _validate()

static var _all_ids: Dictionary[StringName, MapTrigger_OnDialogueChoice] = {}
func _validate() -> void:
	if suppress_error: return
	if dialogue_node_id in _all_ids:
		push_error("Repeating dialogue ID (%s, %s)" % \
			[_all_ids[dialogue_node_id].name, name])
	_all_ids[dialogue_node_id] = self
	return
