@abstract
class_name ObjectLayerObject
extends MapInteractableObject

var layer: MapObjectsLayer:
	get: return map.objects_layer

var tile_data: MapTileData:
	get: return map.get_tile_data(tile_position)

func destroy() -> void:
	layer.set_tile(tile_position)
