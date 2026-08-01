class_name MapUI
extends Node

## Manages the user interface layers and transitions in the game map.
## Handles switching between different UI modes (Main, City, Party, etc.),
## displaying popups/windows for map objects, and tracking active party information.

var current_ui: CanvasLayer
@onready var game_map: GameMap = $".."
@onready var party_layer: PartyUIManager = $Party
@onready var city_layer: CityUIManager = $City

@onready var _active_party_container: VBoxContainer = %ActivePartyContainer
@onready var _party_name_label: Label = %ActivePartyContainer/PartyNameLabel
@onready var _movement_points: TextureProgressBar = %ActivePartyContainer/MovementPoints
@onready var _movement_points_label: Label = %ActivePartyContainer/MovementPoints/Label
@onready var _party_portrait_texture_rect: TextureRect = \
	%ActivePartyContainer/PortraitContainer/PanelContainer/PortraitTextureRect
@onready var pick_up_window: PickUpWindow = %UI_Windows/PickUpWindow
@onready var dialogue_window: DialogueUI = $UI_Windows/DialogueWindow
@onready var item_info_popup: ItemInfoPopup = %UI_Popups/ItemInfoPopup
@onready var party_info_popup: PartyInfoPopup = %UI_Popups/PartyInfoPopup
@onready var object_info_popup: ObjectInfoPopup = %UI_Popups/ObjectInfoPopup
@onready var city_popup: CityInfoPopup = %UI_Popups/CityPopup
@onready var hire_unit_popup: HireUnitPopup = %UI_Popups/HireUnitPopup
@onready var resources_panel: ResourcesManager = %UI_ResourcesPanel
@onready var unit_info_popup: UnitInfoPopup = %UI_Popups/UnitInfoPopup
@onready var hire_hero_popup: HireHeroPopup = $UI_Popups/HireHeroPopup

var last_requested_party: MapParty = null

## Clears the active party display, resetting all UI elements to empty/default states.
## Hides the party portrait and clears movement points and party name displays.
func clear_active_party() -> void:
	_movement_points.value = 0.0
	_movement_points_label.text = ""
	_party_name_label.text = ""
	
	_party_portrait_texture_rect.hide()

## Switches the UI to city mode and populates it with data from the specified [param city]
func switch_to_city(city: MapCity) -> void:
	if not city.object_owner.api.ui_filter: return
	city_layer.fill_city_data(city)
	switch_to(&"City")

## Updates the active party display with information from the specified party.
## Displays movement points, party name, and portrait. Stores the party reference
## in [member last_requested_party] for later use.
## [br][br]
## Note: This only updates the UI display. The party window itself is updated
## by [PartyUIManager] when the window becomes visible.
func fill_active_party(party: MapParty) -> void:
	if not party.object_owner.api.ui_filter: return
	var mp := party.parameters.movement_points
	var max_mp := party.parameters.max_movement_points
	_movement_points.value = mp
	_movement_points.max_value = max_mp
	_movement_points_label.text = "%d/%d" % [mp, max_mp]
	_party_name_label.text = party.party_name
	
	if _party_portrait_texture_rect.texture != party.loaded_portrait:
		_party_portrait_texture_rect.texture = party.loaded_portrait
	_party_portrait_texture_rect.show()
	
	last_requested_party = party

func _switch_ui(target_ui: CanvasLayer) -> void:
	if current_ui:
		current_ui.hide()
		current_ui.set_process(false)
	target_ui.show()
	target_ui.set_process(true)
	current_ui = target_ui

## Switches the current UI mode to the specified interface type.
## [br][br]
## When switching away from "Main" mode, the map is temporarily disabled
## and will automatically re-enable when returning to "Main" mode.
func switch_to(ui: StringName) -> void:
	# WARNING: should probably store the node references in a hashmap
	var target_ui: CanvasLayer = find_child(ui, false)
	if not target_ui:
		push_error("Unknown UI type: %s" % ui)
		return
	if target_ui == current_ui: return
	
	if ui == &"Main": game_map.enable_map()
	elif ui == &"Battle": pass
	else:
		var end_menu_signal := game_map.temporarily_disable_map()
		var switch_callable := switch_to.bind(&"Main")
		
		if not end_menu_signal.is_connected(switch_callable):
			end_menu_signal.connect(switch_callable)
	
	_switch_ui(target_ui)

func _show_hero_data(hero: HeroData) -> bool:
	var f: MapFaction = hero.leading_party.object_owner
	if not f: return false
	var filter := f.api.ui_filter
	if not filter: return false
	
	filter.show_hero_tree.emit(hero)
	return true

## Handles requests to display popups for various map objects.
## Routes the request to the appropriate popup based on the object type.
## 
## Note: This function waits for each popup to close before continuing,
## ensuring popups are shown one at a time.
## This also means that you can call it with [code]await[/code] 
## to continue your execution after the popup is closed.
func handle_popup_request(info_object: Variant) -> void:
	if info_object is MapItem:
		item_info_popup.show_item(info_object)
		await item_info_popup.popup_closed
	elif info_object is MapParty:
		party_info_popup.show_party(info_object)
		await party_info_popup.popup_closed
	elif info_object is MapCity:
		city_popup.show_city(info_object)
	elif info_object is MapInteractableObject:
		object_info_popup.show_object(info_object)
		await object_info_popup.popup_closed
	elif info_object is UnitData:
		if info_object is HeroData:
			if not _show_hero_data(info_object):
				unit_info_popup.show_unit(info_object)
		else: unit_info_popup.show_unit(info_object)
	elif info_object is Array:
		for inner_obj: Variant in info_object:
			await handle_popup_request(inner_obj)
	await get_tree().process_frame

## Handles requests to display windows for various map objects.
## Routes the request to the appropriate window based on the object type.
## [br][br]
## Note: This function waits for each window to close before continuing,
## ensuring windows are shown one at a time.
## This also means that you can call it with [code]await[/code] 
## to continue your execution after the window is closed.
func handle_window_request(info: Variant) -> void:
	if info is DialogueNode:
		dialogue_window.start_dialogue(info)
		await dialogue_window.window_closed
		EventBus.window_closed.emit(info)
	elif info is MapItem:
		pick_up_window.show_item(info)
		await pick_up_window.window_closed
		EventBus.window_closed.emit(info)
	elif info is Array:
		for inner_info: Variant in info:
			await handle_window_request(inner_info)
	await get_tree().process_frame

func _ready() -> void:
	for child in get_children():
		if child is not CanvasLayer: continue
		child.hide()
		child.set_process(false)
	switch_to.call_deferred(&"Main")
	#switch_to.call_deferred(&"Greeting")
	EventBus.popup_requested.connect(handle_popup_request)
	EventBus.window_requested.connect(handle_window_request)
	%VersionLabel.text = ProjectSettings.get_setting("application/config/version")

#func _disconnect_unit_hire() -> void:
	#for d: Dictionary in EventBus.unit_hired.get_connections():
		#d.signal.disconnect(d.callable)
	#for d: Dictionary in hire_unit_popup.popup_closed.get_connections():
		#d.signal.disconnect(d.callable)

## Opens the popup prompting the player to choose a hero for hiring.
## [param source] is an object that creates the party. It is used to determine
## the owner of the party and the location where this party will be spawned.
func open_hero_hire_popup(source: MapInteractableObject, list: Array[StringName]) -> void:
	if not source: return
	if not list: return
	if not source.object_owner: return
	var ui_filter := source.object_owner.api.ui_filter
	if not ui_filter: return
	
	hire_hero_popup.display_for_object(source, list)
	#return null
	#update_city()

## @experimental
func open_hire_popup(base: UnitsContainer, list: Array[StringName]) -> void:
	#hire_unit_popup.unit_hired.connect(update_function)
	hire_unit_popup.display_for_container(base, list)
	#hire_unit_popup.popup_closed.connect(_disconnect_unit_hire)

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Scenes/menu.tscn")
	#get_tree().quit()

func _on_portrait_texture_rect_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if (event as InputEventMouseButton).pressed:
		if not last_requested_party: return
		if last_requested_party.inside_city:
			switch_to_city(last_requested_party.inside_city)
		else: switch_to(&"Party")

func _on_end_turn_button_pressed() -> void:
	var ui_filter := game_map.turn_manager.active_faction.api.ui_filter
	if ui_filter: ui_filter.turn_end_clicked.emit()

func _on_safe_travel_check_box_toggled(toggled_on: bool) -> void:
	GameSettings.safe_travel = toggled_on

func _on_capital_button_pressed() -> void:
	if not game_map.screen_player: return
	$Capital.fill_data(game_map.screen_player)
	switch_to(&"Capital")


func _on_show_tile_ownership_check_box_toggled(toggled_on: bool) -> void:
	GameSettings.show_tile_ownership = toggled_on
