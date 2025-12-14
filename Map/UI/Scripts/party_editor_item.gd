class_name PartyEditorItem
extends Control

@onready var texture_rect: TextureRect = $TextureRect

var item: MapItem

## This method should be called [b]after[/b] [method Node.add_child]
func initialize(_item: MapItem) -> void:
	texture_rect.texture = ImageBuffer.get_image(_item.image_path)
	item = _item


func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT and \
		(event as InputEventMouseButton).pressed:
		EventBus.popup_requested.emit(item)
	
