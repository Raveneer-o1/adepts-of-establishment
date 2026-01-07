extends FactionController

@onready var item_list: ItemList = $EvolutionRequest/InputCatcher/VBoxContainer/ItemList
@onready var evolution_request: CanvasLayer = $EvolutionRequest

func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	return options.pick_random()


func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	EventBus.unit_question_started.emit(unit)
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
	EventBus.unit_question_ended.emit(unit)
	return item_list.get_item_text(index)

func _initialize() -> void:
	api.tile_clicked.connect(api.choose_tile)
	api._ui_filter.turn_end_clicked.connect(api.end_turn)
	api.turn_started.connect(turn_start_reaction)
	
	api._ui_filter.hire_party.connect(api.hire_party)
	api._ui_filter.hire_unit.connect(api.hire_unit)

signal _evolution_choice_made

func _on_button_pressed() -> void:
	if not item_list.get_selected_items(): return
	_evolution_choice_made.emit()

func turn_start_reaction() -> void:
	api.access_player_input()
	api.set_player_at_screen()
