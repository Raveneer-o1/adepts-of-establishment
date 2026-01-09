class_name CapitalUIManager
extends CanvasLayer

const EMPIRE_TREE = preload("uid://b1cbmtd75iavf")
const NECROPOLIS_TREE = preload("uid://b75s5bpy0borb")

var _current_layout: UI_DefaultCapitalLayout

var _faction_to_layout: Dictionary[MapFaction, UI_DefaultCapitalLayout] = {}
func _get_ui_layout(faction: MapFaction) -> UI_DefaultCapitalLayout:
	if not faction: return null
	if _faction_to_layout.has(faction):
		return _faction_to_layout[faction]
	var control: UI_DefaultCapitalLayout = null
	match faction.base_faction:
		GlobalDefs.Faction.Empire: control = EMPIRE_TREE.instantiate()
		GlobalDefs.Faction.Necropolis: control = NECROPOLIS_TREE.instantiate()
	if control: _faction_to_layout[faction] = control
	return control

@onready var active_upgades_item_list: ItemList = \
	%ActiveFactionUpgadesItemList
@onready var selected_active_upgade_text: RichTextLabel = \
	%SelectedActiveFactionUpgadeRichTextLabel

@onready var available_list: ItemList = \
	%BuildingUpgradesItemList
@onready var selected_available_text: RichTextLabel = \
	%SelectedBuildingUpgradesRichTextLabel

@onready var capital_layout_container: MarginContainer = %CapitalLayoutContainer
@onready var active_upgrades: HBoxContainer = $"MarginContainer/TabContainer/Active upgrades"
@onready var ui_layers: MapUI = $".."

@onready var cost_gold: Label = %Build_ResourcePanel_Gold/VBoxContainer/Label
@onready var cost_stone: Label = %Build_ResourcePanel_Stone/VBoxContainer/Label
@onready var cost_mana: Label = %Build_ResourcePanel_Crystals/VBoxContainer/Label


var name_upgrade_mapping: Dictionary[String, FactionUpgrade] = {}
var name_available_mapping: Dictionary[String, FactionUpgrade] = {}

var _selected_available_upgrade: FactionUpgrade = null
var _filled_faction: MapFaction = null

func _fetch_available_upgrades_mapping(faction: MapFaction) -> void:
	name_available_mapping.clear()
	for upgrade in faction.get_available_upgrades(true):
		if name_available_mapping.has(upgrade.upgrade_name):
			push_error("Upgrade '%s' already exists" % upgrade.upgrade_name)
			name_available_mapping[upgrade.upgrade_name + " (%s)" % upgrade.name] = upgrade
		else: name_available_mapping[upgrade.upgrade_name] = upgrade

func _fetch_active_upgrades_mapping(faction: MapFaction) -> void:
	name_upgrade_mapping.clear()
	for upgrade in faction.get_all_upgrades(true):
		if name_upgrade_mapping.has(upgrade.upgrade_name):
			push_error("Upgrade '%s' already exists" % upgrade.upgrade_name)
			name_upgrade_mapping[upgrade.upgrade_name + " (%s)" % upgrade.name] = upgrade
		else: name_upgrade_mapping[upgrade.upgrade_name] = upgrade

func _check_selected(building: StringName) -> void:
	available_list.deselect_all()
	_remove_shown()
	for i in range(available_list.item_count):
		if available_list.get_item_text(i) == building:
			available_list.select(i)
			_show_building(building)
			return
	

func _hide_current_layout() -> void:
	if not _current_layout: return
	_current_layout.hide()
	_current_layout.building_pressed.disconnect(_check_selected)

func _show_current_layout() -> void:
	if not _current_layout: return
	_current_layout.show()
	_current_layout.building_pressed.connect(_check_selected)

func _replace_layout(faction: MapFaction) -> void:
	_hide_current_layout()
	var new_layout := _get_ui_layout(faction)
	_current_layout = new_layout
	if not new_layout: return
	capital_layout_container.add_child(new_layout)
	_show_current_layout()

func fill_data(faction: MapFaction) -> void:
	if not faction: return
	if _filled_faction != faction:
		_replace_layout(faction)
	_filled_faction = faction
	_fetch_active_upgrades_mapping(faction)
	_fetch_available_upgrades_mapping(faction)
	
	active_upgades_item_list.clear()
	for _name in name_upgrade_mapping:
		active_upgades_item_list.add_item(_name)
	
	available_list.clear()
	for _name in name_available_mapping:
		available_list.add_item(_name)
	_remove_shown()

func _remove_shown() -> void:
	selected_available_text.text = ""
	cost_gold.text = "—"
	cost_stone.text = "—"
	cost_mana.text = "—"

func _show_building(upgrade_name: String) -> void:
	if not upgrade_name:
		_remove_shown()
		return
	if not name_available_mapping.has(upgrade_name):
		push_error("Unable to map '%s'" % upgrade_name)
		return
	_selected_available_upgrade = \
		name_available_mapping[upgrade_name]
	selected_available_text.text = \
		_selected_available_upgrade.description
	cost_gold.text = str(_selected_available_upgrade.gold_cost)
	cost_stone.text = str(_selected_available_upgrade.stone_cost)
	cost_mana.text = str(_selected_available_upgrade.mana_cost)

func _on_visibility_changed() -> void:
	if visible == false: return
	fill_data(ui_layers.game_map.screen_player)

func _on_active_faction_upgades_item_list_item_selected(index: int) -> void:
	var upgrade_name := active_upgades_item_list.get_item_text(index)
	if not name_upgrade_mapping.has(upgrade_name):
		push_error("Unable to map '%s'" % upgrade_name)
		return
	selected_active_upgade_text.text = \
		name_upgrade_mapping[upgrade_name].description


func _on_building_upgrades_item_list_item_selected(index: int) -> void:
	var upgrade_name := available_list.get_item_text(index)
	_show_building(upgrade_name)
	_current_layout.show_building(upgrade_name)


func _on_button_pressed() -> void:
	if not _selected_available_upgrade: return
	if not _filled_faction: return
	
	_filled_faction.research(_selected_available_upgrade)
	
	fill_data(_filled_faction)
	
	_selected_available_upgrade = null
	active_upgrades.show()
