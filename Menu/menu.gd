extends Control

@onready var position_0: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer2/Position 0"
@onready var position_1: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Position 1"
@onready var position_2: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer2/Position 2"
@onready var position_3: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Position 3"
@onready var position_4: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer2/Position 4"
@onready var position_5: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Position 5"
@onready var position_6: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer2/Position 6"

@onready var r_position_0: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/Position 0"
@onready var r_position_1: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/Position 1"
@onready var r_position_2: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/Position 2"
@onready var r_position_3: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/Position 3"
@onready var r_position_4: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/Position 4"
@onready var r_position_5: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer/Position 5"
@onready var r_position_6: MenuUnitPlace = $"MarginContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/Position 6"

@onready var item_list_right_controller: ItemList = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ItemList2
@onready var item_list_left_controller: ItemList = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ItemList

@export var battle_scene: PackedScene

var right_array : Array[UnitPanel]:
	get:
		return [
		(r_position_0 as MenuUnitPlace).panel,
		(r_position_1 as MenuUnitPlace).panel,
		(r_position_2 as MenuUnitPlace).panel,
		(r_position_3 as MenuUnitPlace).panel,
		(r_position_4 as MenuUnitPlace).panel,
		(r_position_5 as MenuUnitPlace).panel,
		(r_position_6 as MenuUnitPlace).panel,
]

var left_array : Array[UnitPanel]:
	get:
		return [
		(position_0 as MenuUnitPlace).panel,
		(position_1 as MenuUnitPlace).panel,
		(position_2 as MenuUnitPlace).panel,
		(position_3 as MenuUnitPlace).panel,
		(position_4 as MenuUnitPlace).panel,
		(position_5 as MenuUnitPlace).panel,
		(position_6 as MenuUnitPlace).panel,
]

const DEFAULT_PATH = "res://Party_composition.tscn"

func load_unit_composition() -> void:
	if FileAccess.file_exists(DEFAULT_PATH):
		get_tree().change_scene_to_file(DEFAULT_PATH)

func save_unit_composition() -> void:
	EventBus.packed_menu = PackedScene.new()
	EventBus.packed_menu.pack(self)
	
	ResourceSaver.save(EventBus.packed_menu, DEFAULT_PATH)


const PLAYER_CONTROLLER = 0
const BASIC_AI_CONTROLLER = 1
const STANDARD_AI_CONTROLLER = 2

func save_left_controller() -> void:
	var items := item_list_left_controller.get_selected_items()
	if items.size() == 0:
		print_debug("No items selected on the left!")
		return
	match items[0]:
		PLAYER_CONTROLLER:
			EventBus.left_controller = load("res://Combat/Scenes/player_controller.tscn")
		BASIC_AI_CONTROLLER:
			EventBus.left_controller = load("res://Combat/Scenes/basic_combat_ai.tscn")
		STANDARD_AI_CONTROLLER:
			EventBus.left_controller = load("res://Combat/Scenes/standard_combat_ai.tscn")

func save_right_controller() -> void:
	var items := item_list_right_controller.get_selected_items()
	if items.size() == 0:
		print_debug("No items selected on the right!")
		return
	match items[0]:
		PLAYER_CONTROLLER:
			EventBus.right_controller = load("res://Combat/Scenes/player_controller.tscn")
		BASIC_AI_CONTROLLER:
			EventBus.right_controller = load("res://Combat/Scenes/basic_combat_ai.tscn")
		STANDARD_AI_CONTROLLER:
			EventBus.right_controller = load("res://Combat/Scenes/standard_combat_ai.tscn")


func save_controllers() -> void:
	save_left_controller()
	save_right_controller()


func _on_start_button_pressed() -> void:
	# Clear any existing units from both sides before populating them
	EventBus.left_units.clear()
	EventBus.right_units.clear()
	
	var can_start: bool = false  # Flag to check if the game can start
	
	if OS.is_debug_build():
		can_start = true
	
	var i := -1
	for panel in left_array:
		i += 1
		# If the panel is invalid or null, mark spot as empty by appending an empty string
		if not is_instance_valid(panel) or panel == null:
			#EventBus.left_units.append("")
			continue
		
		var data_obj := (panel as UnitPanel).get_data_object()
		data_obj.party_position = i
		EventBus.left_units.append(data_obj)
		can_start = true  # At least one valid unit is present, so the game can start
	
	i = -1
	for panel in right_array:
		i += 1
		# If the panel is invalid or null, mark spot as empty by appending an empty string
		if not is_instance_valid(panel) or panel == null:
			#EventBus.right_units.append("")
			continue
		
		var data_obj := (panel as UnitPanel).get_data_object()
		data_obj.party_position = i
		EventBus.right_units.append(data_obj)
		can_start = true  # At least one valid unit is present, so the game can start
	
	# If no valid units were added to either side, do not proceed
	if not can_start:
		return
	
	save_controllers()
	
	#var battle_scene := load("res://test.tscn") as PackedScene
	var battle := battle_scene.instantiate()
	process_mode = Node.PROCESS_MODE_DISABLED
	battle.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(battle)
	
	await EventBus.battle_ended
	battle.queue_free()
	process_mode = Node.PROCESS_MODE_ALWAYS
	


func _on_clear_button_pressed() -> void:
	for panel in left_array + right_array:
		if not is_instance_valid(panel) or panel == null:
			continue
		(panel.get_parent() as MenuUnitPlace).clear_child_info()

func _ready() -> void:
	item_list_left_controller.select(STANDARD_AI_CONTROLLER)
	item_list_right_controller.select(PLAYER_CONTROLLER)
	%VesrionLabel.text = ProjectSettings.get_setting("application/config/version")
	EventBus.popup_requested.connect(show_unit)

@onready var unit_info_panel: UnitInfoPanel = $UnitInfoPanel

func show_unit(data: Variant) -> void:
	if data is UnitData:
		unit_info_panel.fill_data(data)
		unit_info_panel.replace_portrait(data.portrait_texture_path)
		unit_info_panel.show()

const MAP_PATH = "res://Map/Scenes/game_map.tscn"

func _on_map_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_PATH)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
