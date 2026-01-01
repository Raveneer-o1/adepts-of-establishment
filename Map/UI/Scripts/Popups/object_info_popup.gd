class_name ObjectInfoPopup
extends PopupBase

@onready var info_label: RichTextLabel = $Root/PanelContainer/MarginContainer/InfoLabel

func show_object(object: MapInteractableObject) -> void:
	if not object: return
	show()
	info_label.text = object.get_description()
