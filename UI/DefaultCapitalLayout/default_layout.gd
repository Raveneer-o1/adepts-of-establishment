class_name UI_DefaultCapitalLayout
extends Control

var _name_to_node: Dictionary[StringName, UI_DefaultCapitalLayout_Node] = {}
var _node_to_tab: Dictionary[UI_DefaultCapitalLayout_Node, Control] = {}

signal building_pressed(building: StringName)

## Registers [param node] for tab navigation.
## When this node is requested by name, displays the associated [param tab].
func register_node(node: UI_DefaultCapitalLayout_Node, tab: Control) -> void:
	assert(node != null)
	assert(not _name_to_node.has(node.building_name),
		"Building %s is already registered" % node.building_name)
	_name_to_node[node.building_name] = node
	_node_to_tab[node] = tab

## Displays the tab containing the specified [param building] if registered
## (via [method register_node] on the corresponding node).
func show_building(building: StringName) -> void:
	if not _name_to_node.has(building): return
	# should not throw an error because the building list is set 
	# while upgrades list is not
	# there could be an upgrade that does not have a corresponding building
	
	var node := _name_to_node[building]
	var tab := _node_to_tab[node]
	tab.show()

func _ready() -> void:
	pass
