class_name MapEvent_Debug
extends MapEvent

func _invoke() -> void:
	print_debug("Debug effect invoked")
	print_stack()
