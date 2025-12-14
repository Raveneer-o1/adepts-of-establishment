class_name MapUI
extends Node

var current_ui: CanvasLayer
@onready var game_map: GameMap = $".."
@onready var party_layer: CanvasLayer = $Party
@onready var city_layer: CityUIManager = $City

@onready var _active_party_container: VBoxContainer = %ActivePartyContainer
@onready var _party_name_label: Label = %ActivePartyContainer/PartyNameLabel
@onready var _movement_points: ProgressBar = %ActivePartyContainer/MovementPoints
@onready var _movement_points_label: Label = %ActivePartyContainer/MovementPoints/Label
@onready var _party_portrait_texture_rect: TextureRect = \
	%ActivePartyContainer/PortraitContainer/PanelContainer/PortraitTextureRect
@onready var item_info_popup: ItemInfoPopup = $ItemInfoPopup

var last_requested_party: MapParty = null

func clear_active_party() -> void:
	_movement_points.value = 0.0
	_movement_points_label.text = ""
	_party_name_label.text = ""
	
	_party_portrait_texture_rect.hide()

func show_item_popup(item: MapItem) -> void:
	item_info_popup.show_item(item)

func show_city_window(city: MapCity) -> void:
	city_layer.fill_city_data(city)
	switch_to(&"City")

## Assigns [param party] to [member last_requested_party]. [br][br]
## Does not update the party window - this occurs only when the player
## actually opens the window. The party UI is updated by [PartyUIManager]
## on visibility change.
func fill_active_party(party: MapParty) -> void:
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

func switch_to(ui: StringName) -> void:
	var target_ui: CanvasLayer = find_child(ui)
	if not target_ui:
		push_error("Unknown UI type: %s" % ui)
		return
	if target_ui == current_ui: return
	
	if ui == &"Main": game_map.enable_map()
	else:
		var end_menu_signal := game_map.temporarily_disable_map()
		var switch_callable := switch_to.bind(&"Main")
		if not end_menu_signal.is_connected(switch_callable):
			end_menu_signal.connect(switch_callable)
	
	_switch_ui(target_ui)

func handle_popup_request(info_object: Variant) -> void:
	if info_object is MapItem:
		show_item_popup(info_object)

func _ready() -> void:
	for child: CanvasLayer in get_children():
		child.hide()
		child.set_process(false)
	switch_to.call_deferred(&"Main")
	EventBus.popup_requested.connect(handle_popup_request)


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_portrait_texture_rect_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if (event as InputEventMouseButton).pressed:
		switch_to(&"Party")

func _on_end_turn_button_pressed() -> void:
	game_map.turn_manager.request_turn_end()
