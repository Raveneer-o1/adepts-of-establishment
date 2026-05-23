class_name MapEvent_ShowDialogue
extends MapEvent

@export var dialogue: DialogueNode
@export var on_dialogue_end: MapEvent

func _invoke() -> void:
	if not dialogue: return
	EventBus.window_requested.emit(dialogue)
	if not on_dialogue_end: return
	await EventBus.window_closed
	on_dialogue_end.invoke()
