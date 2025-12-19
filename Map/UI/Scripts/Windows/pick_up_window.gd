class_name PickUpWindow
extends WindowBase

var currently_shown: Variant

@onready var name_label: Label = \
	$Root/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var texture_rect: TextureRect = \
	$Root/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect

func show_item(item: MapItem) -> void:
	name_label.text = item.item_name
	texture_rect.texture = ImageBuffer.get_image(item.image_path)
	currently_shown = item
	show()

func _on_root_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		hide_window()

func _on_h_box_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			EventBus.popup_requested.emit(currently_shown)
