class_name HireUnitPopup
extends PopupBase

var current_container: UnitsContainer
@onready var ui_layers: MapUI = $"../.."

@onready var units_item_list: ItemList = %HireUnitsItemList
@onready var portrait_texture: TextureRect = %HireUnit_UnitPanel/VBoxContainer/TextureRect
@onready var description: RichTextLabel = %HireUnit_UnitPanel/VBoxContainer/RichTextLabel
@onready var info: RichTextLabel = %HireUnit_UnitPanel/MarginContainer/RichTextLabel
@onready var hire_unit_unit_panel: HBoxContainer = %HireUnit_UnitPanel
@onready var resource_panel_gold: MarginContainer = %HireUnit_ResourcePanel_Gold
@onready var resource_panel_stone: MarginContainer = %HireUnit_ResourcePanel_Stone
@onready var resource_panel_crystals: MarginContainer = %HireUnit_ResourcePanel_Crystals

## Displays the recruitment popup with the specified [param list] of available units.
## When a unit is hired, [UnitData] object is added as a child of [param node].
func display_for_container(node: UnitsContainer, list: Array[StringName]) -> void:
	hire_unit_unit_panel.hide()
	if not node: return
	current_container = node
	show()
	units_item_list.clear()
	for i in list:
		units_item_list.add_item(i)

func _get_resource_label(node: Node) -> Label:
	return node.get_node("VBoxContainer/Label")

func fill_unit_data(data: UnitData) -> void:
	hire_unit_unit_panel.show()
	description.text = data.brief_description
	portrait_texture.texture = DataBuffer.get_image(data.portrait_texture_path)
	var effects := ""
	for e in data.effects:
		effects += "%s, " % e[&"effect_name"]
	effects = effects.trim_suffix(", ")
	info.text = \
"HP = %d
Armor = %d
Evasion = %d
Damage = %d
Effects: %s" % [
		data.max_hp,
		data.armor,
		data.evasion,
		data.base_damage,
		effects
	]
	_get_resource_label(resource_panel_gold).text = str(data.cost.gold)
	_get_resource_label(resource_panel_stone).text = str(data.cost.stone)
	_get_resource_label(resource_panel_crystals).text = str(data.cost.mana)


func _on_hire_button_pressed() -> void:
	var ui_filter := ui_layers.game_map.turn_manager.active_faction.api.ui_filter
	if not ui_filter: return
	for item in units_item_list.get_selected_items():
		var unit_name := units_item_list.get_item_text(item)
		if ui_layers.game_map.screen_player:
			ui_filter.hire_unit.emit(unit_name, current_container)

func _on_hire_units_item_list_item_selected(index: int) -> void:
	var unit_name: StringName = units_item_list.get_item_text(index)
	var data := DataBuffer.get_unit_data(unit_name)
	if not data: return
	fill_unit_data(data)
