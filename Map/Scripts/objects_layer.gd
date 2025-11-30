class_name MapObjectsLayer
extends TileMapLayer

var map: Map

## [color=red]Warning: [color=pink]this is specific to [TileSet] resource,
## should be changed every time source ID changes.[/color]
const SCENE_SOURCE_ID = 13

func _clear_refs (coords: Vector2i) -> void:
	var prev_objs := map.get_objects_on_tile(coords)
	for o in prev_objs:
		if not is_instance_valid(o) or o.is_queued_for_deletion():
			map.clear_object_refs(o)

func set_tile(
	coords: Vector2i,
	scene_id: int = -1
) -> void:
	set_cell(coords, SCENE_SOURCE_ID, Vector2i(0, 0), scene_id)
	call_deferred(&"_clear_refs", coords)
