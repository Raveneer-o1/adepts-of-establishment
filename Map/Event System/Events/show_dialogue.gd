class_name MapEvent_ShowDialogue
extends MapEvent

@export var dialogue: DialogueNode

func _invoke() -> void:
	if not dialogue: return
	EventBus.window_requested.emit(dialogue)
