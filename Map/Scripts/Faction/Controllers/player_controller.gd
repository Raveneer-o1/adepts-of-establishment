extends FactionController

@onready var item_list: ItemList = $EvolutionRequest/InputCatcher/VBoxContainer/ItemList
@onready var evolution_request: CanvasLayer = $EvolutionRequest
@onready var hero_levelup: CanvasLayer = $HeroLevelup
@onready var levelups_container: Control = \
	$HeroLevelup/MarginContainer/PanelContainer/MarginContainer

signal _evolution_choice_made
signal _hero_ability_choice_made
signal __trigger

const DYNAMIC_TREE = preload("uid://dgfpqcsfd2ewx")

var _chosen_hero_ability: HeroAbility
var hero_to_dynamic_tree: Dictionary[HeroData, UI_DynamicTree] = {}

func _check_ability(ability: HeroAbility, options: Array[HeroAbility]) -> void:
	if ability in options:
		_chosen_hero_ability = ability
		_hero_ability_choice_made.emit(ability)

func _read_chosen_ability(ability: HeroAbility) -> HeroAbility:
	return ability

func _get_chosen_ability(
	hero: HeroData,
	tree: UI_DynamicTree,
	options: Array[HeroAbility]
) -> HeroAbility:
	var callable := _check_ability.bind(options)
	tree.ability_selected.connect(callable)
	
	await _hero_ability_choice_made
	
	tree.ability_selected.disconnect(callable)
	tree.hide()
	hero_levelup.hide()
	return _chosen_hero_ability

func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	await api.game.screen_access(api.this_faction, __trigger)
	api.global_pause()
	
	var ui_tree := _show_hero_tree(hero)
	var res := await _get_chosen_ability(hero, ui_tree, options)
	api.global_unpause()
	return res

func _show_hero_tree(hero: HeroData) -> UI_DynamicTree:
	var ui_tree: UI_DynamicTree = hero_to_dynamic_tree.get(hero)
	if not ui_tree:
		ui_tree = DYNAMIC_TREE.instantiate()
		levelups_container.add_child(ui_tree)
		#hero_levelup.add_child(ui_tree)
		hero_to_dynamic_tree[hero] = ui_tree
	hero_levelup.show()
	ui_tree.show()
	ui_tree.build_tree(hero.hero_levelup)
	return ui_tree

func _show_hero_tree_no_levelup(hero: HeroData) -> void:
	api.global_pause()
	var ui_tree := _show_hero_tree(hero)
	ui_tree.input_closes_window = true
	await ui_tree.close_requested
	ui_tree.hide()
	hero_levelup.hide()
	api.global_unpause()

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	EventBus.unit_question_started.emit(unit)
	item_list.clear()
	for option in options:
		item_list.add_item(option)
	evolution_request.show()
	api.global_pause()
	await _evolution_choice_made
	api.global_unpause()
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
	api._ui_filter.research_upgrade.connect(api.research)
	api._ui_filter.show_hero_tree.connect(_show_hero_tree_no_levelup)

func _on_button_pressed() -> void:
	if not item_list.get_selected_items(): return
	_evolution_choice_made.emit()

func turn_start_reaction() -> void:
	api.access_player_input()
	api.set_player_at_screen()
