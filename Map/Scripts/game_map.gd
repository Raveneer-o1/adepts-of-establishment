class_name GameMap
extends Node

const test_map = preload("res://Map/Scenes/map.tscn")

var current_map: Map

func enable_map() -> void:
	current_map.process_mode = Node.PROCESS_MODE_PAUSABLE

func disable_map() -> void:
	current_map.process_mode = Node.PROCESS_MODE_DISABLED

var _temporarily_disabled := false
signal _temp_disabled_ended

func temporarily_disable_map() -> Signal:
	disable_map()
	_temporarily_disabled = true
	return _temp_disabled_ended

func load_maps() -> void:
	current_map = test_map.instantiate()
	$MapsContainer.add_child(current_map)

func _ready() -> void:
	load_maps()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed(): return
	if _temporarily_disabled:
		if (event as InputEventKey).keycode == Key.KEY_ESCAPE:
			enable_map()
			_temp_disabled_ended.emit()
			for d: Dictionary in _temp_disabled_ended.get_connections():
				_temp_disabled_ended.disconnect(d.callable)
