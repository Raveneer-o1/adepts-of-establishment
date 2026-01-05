class_name PartyEditorItem
extends Control

@onready var texture_rect: TextureRect = $TextureRect

var item: MapItem

func _check_used_item(_item: MapItem) -> void:
	if _item != item: return
	if item.is_queued_for_deletion(): queue_free()

## This method should be called [b]after[/b] [method Node.add_child]
func initialize(_item: MapItem) -> void:
	texture_rect.texture = ImageBuffer.get_image(_item.image_path)
	item = _item
	EventBus.item_used.connect(_check_used_item)

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT and \
		(event as InputEventMouseButton).pressed:
		EventBus.popup_requested.emit(item)

func get_preview() -> Control:
	var drag_obj := PartyEditorDragObject.new(item.item_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return item
