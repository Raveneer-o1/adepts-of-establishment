class_name MapEvent_MoveCamera
extends MapEvent

@export var target: Node2D

func _invoke() -> void:
	if not target: return
	map.camera.force_to_position(target.global_position)
