extends PanelContainer
class_name DragObject

var unit_name: String = "Placeholder"

func _init(name_of_the_unit: String) -> void:
	unit_name = name_of_the_unit

func _ready() -> void:
	var container := MarginContainer.new()
	var label := Label.new()
	label.text = unit_name
	container.add_child(label)
	container.add_theme_constant_override("margin_left", 12)
	container.add_theme_constant_override("margin_right", 12)
	container.add_theme_constant_override("margin_top", 8)
	container.add_theme_constant_override("margin_bottom", 8)
	add_child(container)
