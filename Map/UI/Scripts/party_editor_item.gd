class_name PartyEditorItem
extends Control

@onready var texture_rect: TextureRect = $TextureRect

var item: MapItem

## This method should be called [b]after[/b] [method Node.add_child]
func initialize(_item: MapItem) -> void:
	texture_rect.texture = ImageBuffer.get_image(_item.image_path)
	item = _item
