class_name PartyEditorUnit
extends Control

@onready var label: Label = $PanelContainer/Label
var unit_data: UnitData

func _ready() -> void:
	if not unit_data: queue_free()
	else: label.text = unit_data.unit_name

func get_preview() -> Control:
	var drag_obj := PartyEditorUnitDragObject.new(unit_data.unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
