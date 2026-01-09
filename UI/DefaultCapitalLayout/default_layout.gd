class_name UI_DefaultCapitalLayout
extends Control

var _name_to_node: Dictionary[StringName, UI_DefaultCapitalLayout_Node] = {}
var _node_to_tab: Dictionary[UI_DefaultCapitalLayout_Node, Control] = {}

signal building_pressed(building: StringName)

func register_node(node: UI_DefaultCapitalLayout_Node, tab: Control) -> void:
	assert(node != null)
	assert(not _name_to_node.has(node.building_name),
		"Building %s is already registered" % node.building_name)
	_name_to_node[node.building_name] = node
	_node_to_tab[node] = tab

func show_building(building: StringName) -> void:
	assert(_name_to_node.has(building),
		"Building %s is not registered" % building)
	var node := _name_to_node[building]
	var tab := _node_to_tab[node]
	tab.show()

func _ready() -> void:
	pass
