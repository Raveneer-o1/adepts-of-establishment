class_name HireUnitPopup
extends PopupBase

var current_container: Node
signal unit_hired(unit: UnitData)
@onready var ui_layers: MapUI = $"../.."

@onready var units_item_list: ItemList = %HireUnitsItemList

## Displays the recruitment popup with the specified [param list] of available units.
## When a unit is hired, [UnitData] object is added as a child of [param node].
func display_for_container(node: Node, list: Array[StringName]) -> void:
	if not node: return
	current_container = node
	show()
	units_item_list.clear()
	for i in list:
		units_item_list.add_item(i)

func _on_hire_button_pressed() -> void:
	for item in units_item_list.get_selected_items():
		var unit_name := units_item_list.get_item_text(item)
		if ui_layers.game_map.screen_player:
			var data := ui_layers.game_map.screen_player.api.hire_unit(
				unit_name, current_container)
			if data: unit_hired.emit(data)
