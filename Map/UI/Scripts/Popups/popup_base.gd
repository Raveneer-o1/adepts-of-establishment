@abstract
class_name PopupBase
extends CanvasLayer

signal popup_closed

func hide_popup() -> void:
	hide()
	popup_closed.emit()
