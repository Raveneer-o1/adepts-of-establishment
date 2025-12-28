class_name HireUnitPopup
extends PopupBase

var current_container: Node
signal unit_hired(unit: UnitData)

@onready var units_item_list: ItemList = \
	$Control/PanelContainer/MarginContainer/VBoxContainer/UnitsItemList

func display_for_container(node: Node) -> void:
	if not node: return
	current_container = node
	show()

func hire(unit_name: String) -> void:
	var data := UnitData.new()
	data.unit_name = unit_name
	data.initialize()
	current_container.add_child(data)
	unit_hired.emit(data)


func _on_hire_button_pressed() -> void:
	for item in units_item_list.get_selected_items():
		hire(units_item_list.get_item_text(item))
