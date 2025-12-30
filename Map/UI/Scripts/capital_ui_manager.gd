class_name CapitalUIManager
extends CanvasLayer

@onready var active_upgades_item_list: ItemList = \
	%ActiveFactionUpgadesItemList
@onready var selected_active_upgade_text: RichTextLabel = \
	%SelectedActiveFactionUpgadeRichTextLabel

@onready var avaliable_list: ItemList = \
	%BuildingUpgradesItemList
@onready var selected_avaliable_text: RichTextLabel = \
	%SelectedBuildingUpgradesRichTextLabel

@onready var ui_layers: MapUI = $".."

var name_upgrade_mapping: Dictionary[String, FactionUpgrade] = {}
var name_avaliable_mapping: Dictionary[String, FactionUpgrade] = {}

var _selected_avaliable_upgrade: FactionUpgrade = null
var _filled_faction: MapFaction = null

func _fetch_avaliable_upgrades_mapping(faction: MapFaction) -> void:
	name_avaliable_mapping.clear()
	for upgrade in faction.get_avaliable_upgrades(true):
		if name_avaliable_mapping.has(upgrade.upgrade_name):
			push_error("Upgrade '%s' already exists" % upgrade.upgrade_name)
			name_avaliable_mapping[upgrade.upgrade_name + upgrade.name] = upgrade
		else: name_avaliable_mapping[upgrade.upgrade_name] = upgrade

func _fetch_active_upgrades_mapping(faction: MapFaction) -> void:
	name_upgrade_mapping.clear()
	for upgrade in faction.get_all_upgrades(true):
		if name_upgrade_mapping.has(upgrade.upgrade_name):
			push_error("Upgrade '%s' already exists" % upgrade.upgrade_name)
			name_upgrade_mapping[upgrade.upgrade_name + upgrade.name] = upgrade
		else: name_upgrade_mapping[upgrade.upgrade_name] = upgrade

func fill_data(faction: MapFaction) -> void:
	if not faction: return
	_filled_faction = faction
	_fetch_active_upgrades_mapping(faction)
	_fetch_avaliable_upgrades_mapping(faction)
	
	active_upgades_item_list.clear()
	for _name in name_upgrade_mapping:
		active_upgades_item_list.add_item(_name)
	
	avaliable_list.clear()
	for _name in name_avaliable_mapping:
		avaliable_list.add_item(_name)

func _on_visibility_changed() -> void:
	if visible == false: return
	fill_data(ui_layers.game_map.screen_player)

func _on_active_faction_upgades_item_list_item_selected(index: int) -> void:
	var unit_name := active_upgades_item_list.get_item_text(index)
	if not name_upgrade_mapping.has(unit_name):
		push_error("Unable to map '%s'" % unit_name)
		return
	selected_active_upgade_text.text = \
		name_upgrade_mapping[unit_name].description


func _on_building_upgrades_item_list_item_selected(index: int) -> void:
	var unit_name := avaliable_list.get_item_text(index)
	if not name_avaliable_mapping.has(unit_name):
		push_error("Unable to map '%s'" % unit_name)
		return
	_selected_avaliable_upgrade = \
		name_avaliable_mapping[unit_name]
	selected_avaliable_text.text = \
		_selected_avaliable_upgrade.description


func _on_button_pressed() -> void:
	if not _selected_avaliable_upgrade: return
	if not _filled_faction: return
	
	_filled_faction.research(_selected_avaliable_upgrade)
	
	fill_data(_filled_faction)
