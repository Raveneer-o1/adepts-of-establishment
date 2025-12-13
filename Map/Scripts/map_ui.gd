class_name MapUI
extends Node

var current_ui: CanvasLayer
@onready var game_map: GameMap = $".."
@onready var party_layer: CanvasLayer = $Party

var last_requested_party: MapParty = null

## Assigns [param party] to [member last_requested_party]. [br][br]
## Does not update the party window - this occurs only when the player
## actually opens the window. The party UI is updated by [PartyUIManager]
## on visibility change.
func fill_active_party(party: MapParty) -> void:
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

func _ready() -> void:
	for child: CanvasLayer in get_children():
		child.hide()
		child.set_process(false)
	switch_to.call_deferred(&"Main")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_portrait_texture_rect_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if (event as InputEventMouseButton).pressed:
		switch_to(&"Party")

func _on_end_turn_button_pressed() -> void:
	var active_faction := game_map.turn_manager.active_faction
	if active_faction: active_faction.api.end_turn_clicked.emit()
