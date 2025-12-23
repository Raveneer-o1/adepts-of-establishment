class_name PartyEditorUnit
extends Control

@onready var label: Label = $PanelContainer/Label

## @experimental: may be changed to always return the [UnitData] object.
## Returns the [UnitData] object associated with this node, or 
## [member UnitData.original] if that field is set. [br]
## Currently returns the original reference to support the data refresh algorithm
## (see [method PartyUIManager._update_values]), but this implementation may evolve
## as other systems may require access to the modified data.
var unit_data: UnitData:
	get: return unit_data.original \
		if unit_data and unit_data.original \
		else unit_data
	set(value):
		unit_data = value

func update_data() -> void:
	# TODO: implement visual representatoin of a unit and update it here
	pass

func _ready() -> void:
	if not unit_data: queue_free()
	else: label.text = unit_data.unit_name

func get_preview() -> Control:
	var drag_obj := PartyEditorUnitDragObject.new(unit_data.unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
