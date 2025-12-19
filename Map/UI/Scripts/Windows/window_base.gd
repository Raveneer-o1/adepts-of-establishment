@abstract
class_name WindowBase
extends CanvasLayer

signal window_closed

func hide_window() -> void:
	hide()
	window_closed.emit()
