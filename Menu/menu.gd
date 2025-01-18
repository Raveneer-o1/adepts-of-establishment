extends Control

#const COMMUNICATION_PATH = "res://unit_array.gd"

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
const STANDART_AI_CONTROLLER = 2

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
		STANDART_AI_CONTROLLER:
			EventBus.left_controller = load("res://Combat/Scenes/standart_combat_ai.tscn")

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
		STANDART_AI_CONTROLLER:
			EventBus.right_controller = load("res://Combat/Scenes/standart_combat_ai.tscn")


func save_controllers() -> void:
	save_left_controller()
	save_right_controller()


func _on_start_button_pressed() -> void:
	# Clear any existing units from both sides before populating them
	EventBus.left_units.clear()
	EventBus.right_units.clear()
	
	var can_start: bool = false  # Flag to check if the game can start
	
	# Process the left unit panels
	for panel in left_array:
		# If the panel is invalid or null, mark spot as empty by appending an empty string
		if not is_instance_valid(panel) or panel == null:
			EventBus.left_units.append("")
			continue
		
		EventBus.left_units.append((panel as UnitPanel).directory)
		can_start = true  # At least one valid unit is present, so the game can start
	
	# Process the right unit panels
	for panel in right_array:
		# If the panel is invalid or null, mark spot as empty by appending an empty string
		if not is_instance_valid(panel) or panel == null:
			EventBus.right_units.append("")
			continue
		
		EventBus.right_units.append((panel as UnitPanel).directory)
		can_start = true  # At least one valid unit is present, so the game can start
	
	# If no valid units were added to either side, do not proceed
	if not can_start:
		return
	
	save_controllers()
	
	
	save_unit_composition()
	
	# Change the current scene to the test scene
	get_tree().change_scene_to_file("res://test.tscn")


func _on_clear_button_pressed() -> void:
	for panel in left_array + right_array:
		if not is_instance_valid(panel) or panel == null:
			continue
		(panel.get_parent() as MenuUnitPlace).clear_child_info()
		panel.queue_free()

func _ready() -> void:
	item_list_left_controller.select(STANDART_AI_CONTROLLER)
	item_list_right_controller.select(PLAYER_CONTROLLER)
