extends PanelContainer
class_name TreeItemUnit

@export var unit_name: String
@export_file("*.tscn") var path: String
@onready var label: Label = $MarginContainer/Label

const TOOLTIP_UNFINISHED = "Unfinished content. This unit will be available in future versions."
var _active := true

func get_preview() -> Control:
	var drag_obj := DragObject.new(unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	if not _active: return null
	set_drag_preview(get_preview())
	return self

func _ready() -> void:
	label.text = unit_name
	if not GlobalDefs.units_database.database.has(unit_name):
		_active = false
		tooltip_text = TOOLTIP_UNFINISHED

func _on_gui_input(event: InputEvent) -> void:
	if not _active: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				EventBus.popup_requested.emit(DataBuffer.get_unit_data(unit_name))
