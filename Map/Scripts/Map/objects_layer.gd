class_name MapObjectsLayer
extends TileMapLayer

var map: Map

# ATTENTION
## [color=red]Warning: [color=pink]this is specific to [TileSet] resource,
## should be changed every time source ID changes.[/color]
const SCENE_SOURCE_ID = 13

func _clear_refs (coords: Vector2i) -> void:
	var prev_objs: Array[MapInteractableObject] = map.tile_to_object.get(coords, [])
	for o in prev_objs:
		if not is_instance_valid(o) or o.is_queued_for_deletion():
			map.clear_object_refs(o)

## Returns [ObjectLayerObject] on the specified tile on [code]null[/code]
## if the tile is empty
func get_object(coords: Vector2i) -> ObjectLayerObject:
	for o: MapInteractableObject in map.tile_to_object.get(coords, []):
		if o is ObjectLayerObject: return o
	return null

## Changes the cell at specified [param coords] to [param scene_id].
## IDs can be found in the [TileSet] settings. Value of [code]-1[/code] erases the tile.
func set_tile(
	coords: Vector2i,
	scene_id: int = -1
) -> void:
	set_cell(coords, SCENE_SOURCE_ID, Vector2i(0, 0), scene_id)
	call_deferred(&"_clear_refs", coords)
