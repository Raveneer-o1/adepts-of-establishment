@abstract
class_name PopupBase
extends CanvasLayer

## Base class for informational popups requested by player interaction.
##
## Popups display player-requested information, typically triggered by
## right-clicking objects. [br][br]
## Derived classes must contain at least one [Control] node as a child.
## The first [Control] child captures input and enables automatic popup closure.

signal popup_closed

func hide_popup() -> void:
	hide()
	popup_closed.emit()

func _ready() -> void:
	var c: Control = null
	for child in get_children():
		if child is Control:
			c = child
			break
	if not c: return
	#c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.gui_input.connect(_on_root_gui_input)

func _on_root_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		hide_popup()
