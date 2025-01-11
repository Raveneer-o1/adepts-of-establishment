extends Control

const COMMUNICATION_PATH = "res://unit_array.gd"

@onready var position_0: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 0"
@onready var position_1: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer/Position 1"
@onready var position_2: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 2"
@onready var position_3: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer/Position 3"
@onready var position_4: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 4"
@onready var position_5: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer/Position 5"
@onready var position_6: MenuUnitPlace = $"HBoxContainer/VBoxContainer2/VBoxContainer2/Position 6"

func _on_start_button_pressed() -> void:
	var array := [
			(position_0 as MenuUnitPlace).panel,
			(position_1 as MenuUnitPlace).panel,
			(position_2 as MenuUnitPlace).panel,
			(position_3 as MenuUnitPlace).panel,
			(position_4 as MenuUnitPlace).panel,
			(position_5 as MenuUnitPlace).panel,
			(position_6 as MenuUnitPlace).panel,
	]
	
	EventBus.left_units.clear()
	for panel in array:
		if panel == null:
			EventBus.left_units.append("")
			continue
		EventBus.left_units.append((panel as UnitPanel).directory)
	get_tree().change_scene_to_file("res://test.tscn")
