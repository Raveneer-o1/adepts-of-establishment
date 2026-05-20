class_name MapTrigger_OnDialogueChoice
extends MapTrigger

@export var dialogue_node_id := &""

func _check_id(id: StringName) -> void:
	if id == dialogue_node_id:
		trigger()
		#print_debug("Triggered")

func _initialize() -> void:
	EventBus.dialogue_id_selected.connect(_check_id)
	assert(_validate())

static var all_ids: Dictionary
func _validate() -> bool:
	if dialogue_node_id in all_ids:
		push_error("Repeating dialogue ID")
	all_ids[dialogue_node_id] = null
	return true
