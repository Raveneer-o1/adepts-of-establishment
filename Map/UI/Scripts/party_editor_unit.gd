class_name PartyEditorUnit
extends MarginContainer

@onready var label: Label = $PanelContainer/Label

const REGULAR_COLOR = Color.WHITE
const HERO_COLOR = Color.LIGHT_SEA_GREEN

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
	if not unit_data:
		queue_free()
		return
	label.text = unit_data.unit_name
	label.self_modulate = HERO_COLOR if unit_data is HeroData else REGULAR_COLOR

func get_preview() -> Control:
	var drag_obj := PartyEditorDragObject.new(unit_data.unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#print(data)
	if data is MapItem:
		return data.can_be_applied_to(unit_data)
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is MapItem:
		data.apply_to(unit_data)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				EventBus.popup_requested.emit(unit_data)
				get_viewport().set_input_as_handled()
			else:
				EventBus.popup_closure_requested.emit()


func _on_mouse_exited() -> void:
	EventBus.popup_closure_requested.emit()
