extends Panel
class_name UnitPanel

@onready var label: Label = $Label

var directory: String

var label_text: String:
	get:
		return label.text
	set(value):
		label.text = value

func get_preview() -> Control:
	var drag_obj := DragObject.new(label_text)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
