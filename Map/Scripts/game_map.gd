extends Control

const test_map = preload("res://Map/Scenes/map.tscn")

func load_maps() -> void:
	$MapsContainer.add_child(test_map.instantiate())

func _ready() -> void:
	load_maps()
