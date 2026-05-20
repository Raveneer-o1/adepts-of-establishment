class_name MapPin
extends Node2D

## A marker that can be placed on a map in the editor.
##
## The sole purpose of a pin is to provide coordinates to other objects.
## At game start, the pin automatically determines its tile location and stores
## it in [member tile_position]. Map designers can place pins directly in the
## editor to mark specific tiles (e.g., to mark an area), and other objects
## (such as events) can reference the pin to obtain those coordinates at runtime.

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
