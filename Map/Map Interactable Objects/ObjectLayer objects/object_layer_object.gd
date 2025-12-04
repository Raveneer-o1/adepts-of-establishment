@abstract
class_name ObjectLayerObject
extends MapInteractableObject

func destroy() -> void:
	map.free_map_object(self)
