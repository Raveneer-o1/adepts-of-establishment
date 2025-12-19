class_name ItemInfoPopup
extends CanvasLayer

@onready var name_label: Label = $Root/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var texture_rect: TextureRect = $Root/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var rich_text_label: RichTextLabel = $Root/PanelContainer/MarginContainer/VBoxContainer/RichTextLabel

func show_item(item: MapItem) -> void:
	name_label.text = item.item_name
	texture_rect.texture = ImageBuffer.get_image(item.image_path)
	show()

func _on_root_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		hide()
