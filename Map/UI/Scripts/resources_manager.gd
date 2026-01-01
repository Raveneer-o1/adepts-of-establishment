class_name ResourcesManager
extends PanelContainer

@onready var ui_resource_panel_gold: MarginContainer = %UI_ResourcePanel_Gold
@onready var ui_resource_panel_stone: MarginContainer = %UI_ResourcePanel_Stone
@onready var ui_resource_panel_crystals: MarginContainer = %UI_ResourcePanel_Crystals

var _currently_filled: MapResourceContainer = null:
	set(value):
		if value == _currently_filled: return
		if _currently_filled and \
			_currently_filled.reserve_updated.is_connected(update_values):
				_currently_filled.reserve_updated.disconnect(update_values)
		value.reserve_updated.connect(update_values)
		_currently_filled = value

## @experimental: has to be rewritten if UI structue changes
func get_TextureRect(node: Node) -> TextureRect:
	return node.find_child("TextureRect")

## @experimental: has to be rewritten if UI structue changes
func get_Label(node: Node) -> Label:
	return node.find_child("Label")

func _reset_contents() -> void:
	get_Label(ui_resource_panel_gold).text = "—"
	get_Label(ui_resource_panel_stone).text = "—"
	get_Label(ui_resource_panel_crystals).text = "—"
	_currently_filled = null

func update_values() -> void:
	pass

func fill_data(container: MapResourceContainer) -> void:
	if _currently_filled == container:
		update_values()
		return
	if not container:
		_reset_contents()
		return
	
	get_Label(ui_resource_panel_gold).text = str(container.gold)
	get_Label(ui_resource_panel_stone).text = str(container.stone)
	get_Label(ui_resource_panel_crystals).text = str(container.mana)
	
	_currently_filled = container
