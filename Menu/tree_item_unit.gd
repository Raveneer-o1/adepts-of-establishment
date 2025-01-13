extends PanelContainer

class_name TreeItemUnit

@export var unit_name: String
@export_dir var path: String
@onready var label: Label = $MarginContainer/Label

func get_preview() -> Control:
	var drag_obj := DragObject.new(unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self

func _ready() -> void:
	label.text = unit_name
