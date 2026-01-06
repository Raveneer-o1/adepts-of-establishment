extends PanelContainer
class_name TreeItemUnit

@export var unit_name: String
@export_file("*.tscn") var path: String
@onready var label: Label = $MarginContainer/Label

func get_preview() -> Control:
	var drag_obj := DragObject.new(unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self

func _ready() -> void:
	label.text = unit_name


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				EventBus.popup_requested.emit(DataBuffer.get_unit_data(unit_name))
