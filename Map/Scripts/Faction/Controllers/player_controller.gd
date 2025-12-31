extends FactionController

@onready var item_list: ItemList = $EvolutionRequest/InputCatcher/VBoxContainer/ItemList
@onready var evolution_request: CanvasLayer = $EvolutionRequest

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	item_list.clear()
	for option in options:
		item_list.add_item(option)
	evolution_request.show()
	api.gloabal_pause()
	await _evolution_choice_made
	api.gloabal_unpause()
	evolution_request.hide()
	var selected := item_list.get_selected_items()
	if not selected: return options.pick_random()
	var index := selected[0]
	return item_list.get_item_text(index)

func turn_start_reaction() -> void:
	api.access_player_input()
	api.set_player_at_screen()

func _initialize() -> void:
	api.tile_clicked.connect(api.choose_tile)
	api.end_turn_clicked.connect(api.end_turn)
	api.turn_started.connect(turn_start_reaction)

signal _evolution_choice_made

func _on_button_pressed() -> void:
	_evolution_choice_made.emit()
