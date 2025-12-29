class_name CapitalUIManager
extends CanvasLayer

@onready var active_upgades_item_list: ItemList = \
	%ActiveFactionUpgadesItemList
@onready var selected_active_upgade_text: RichTextLabel = \
	%SelectedActiveFactionUpgadeRichTextLabel

@onready var ui_layers: MapUI = $".."

var name_upgrade_mapping: Dictionary[String, FactionUpgrade] = {}

func _fetch_mapping(faction: MapFaction) -> void:
	for upgrade in faction.get_all_upgrades():
		if name_upgrade_mapping.has(upgrade.upgrade_name):
			push_error("Upgrade '%s' already exists")
			name_upgrade_mapping[upgrade.upgrade_name + upgrade.name] = upgrade
		else: name_upgrade_mapping[upgrade.upgrade_name] = upgrade

func fill_data(faction: MapFaction) -> void:
	_fetch_mapping(faction)
	for _name in name_upgrade_mapping:
		active_upgades_item_list.add_item(_name)

func _on_visibility_changed() -> void:
	fill_data(ui_layers.game_map.screen_player)
