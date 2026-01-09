class_name UI_DefaultCapitalLayout_Node
extends Button

@export var next_nodes: Array[UI_DefaultCapitalLayout_Node]

@onready var building_name: StringName = text

var layout: UI_DefaultCapitalLayout

func _register() -> void:
	var parent := get_parent()
	var prev_parent: Node = parent
	var tab: Node = self
	while parent:
		if parent is TabContainer:
			tab = prev_parent
		if parent is UI_DefaultCapitalLayout:
			layout = parent
			parent.register_node(self, tab)
			return
		prev_parent = parent
		parent = parent.get_parent()
	push_error("Unable to find 'UI_DefaultCapitalLayout'")
	queue_free()

func _ready() -> void:
	_register()

func _on_pressed() -> void:
	layout.building_pressed.emit(building_name)
