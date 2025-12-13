@abstract
class_name ObjectLayerObject
extends MapInteractableObject

var layer: MapObjectsLayer:
	get: return map.objects_layer

func destroy() -> void:
	layer.set_tile(tile_position)
