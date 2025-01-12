extends Panel
class_name UnitPanel

@onready var label: Label = $Label

@export var directory: String

@export var unit_name: String

#var label_text: String:
	#get:
		#return label.text
	#set(value):
		#label.text = value

func _ready() -> void:
	label.text = unit_name
	label.owner = owner

func get_preview() -> Control:
	var drag_obj := DragObject.new(unit_name)
	return drag_obj

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
