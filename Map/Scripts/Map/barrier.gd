extends Node2D

var map: Map
var tile_position: Vector2i
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map (Barrier)")
		queue_free()
		return
	if not map.is_node_ready(): await map.ready
	tile_position = map.get_tile_coords(global_position)
	var td: MapTileData = map.tile_data_hashmap.get(tile_position)
	if not td:
		push_error("Barrier is placed on an empty tile")
		queue_free()
		return
	td.set_as_unused()
	hide()
