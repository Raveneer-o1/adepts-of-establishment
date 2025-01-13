extends Control

#const COMMUNICATION_PATH = "res://unit_array.gd"

@onready var position_0: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 0"
@onready var position_1: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer/Position 1"
@onready var position_2: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 2"
@onready var position_3: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer/Position 3"
@onready var position_4: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 4"
@onready var position_5: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer/Position 5"
@onready var position_6: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 6"

@onready var r_position_0: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer2/Position 0"
@onready var r_position_1: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer/Position 1"
@onready var r_position_2: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer2/Position 2"
@onready var r_position_3: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer/Position 3"
@onready var r_position_4: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer2/Position 4"
@onready var r_position_5: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer/Position 5"
@onready var r_position_6: MenuUnitPlace = $"HBoxContainer/VBoxContainer3/VBoxContainer2/Position 6"


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
	
	# Prepare to save the current menu scene as a packed scene
	EventBus.packed_menu = PackedScene.new()
	await (EventBus.packed_menu.pack(self))
	
	# Change the current scene to the test scene
	get_tree().change_scene_to_file("res://test.tscn")


func _on_clear_button_pressed() -> void:
	for panel in left_array + right_array:
		if not is_instance_valid(panel) or panel == null:
			continue
		(panel.get_parent() as MenuUnitPlace).clear_child_info()
		panel.queue_free()
