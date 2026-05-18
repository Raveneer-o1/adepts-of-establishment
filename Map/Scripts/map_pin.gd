class_name MapPin
extends Node2D

var map: Map
var tile_position: Vector2i

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map (Pin)")
		queue_free()
		return
	if not map.is_node_ready(): await map.ready
	tile_position = map.get_tile_coords(global_position)
