@abstract
class_name WindowBase
extends CanvasLayer

## Base class for system-initiated windows displaying information to the player.
##
## Windows present information not necessarily requested by the player,
## such as resource deficiency notifications or discovery alerts. [br][br]
## Derived classes must implement closure functionality (e.g., via dedicated
## button or ESC key) that calls [method hide_window].
## 

signal window_closed

func hide_window() -> void:
	hide()
	window_closed.emit()
