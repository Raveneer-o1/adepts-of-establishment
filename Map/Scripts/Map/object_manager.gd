class_name MapObjectManager
extends Node

@onready var map: Map = $".."

## Instantiates provided [param prefab], adds is as a child to the
## [MapObjectManager].[br]
## Returns instantiated object or [code]null[/code] if failed
func add_object(prefab: PackedScene, coords: Vector2i) -> MapInteractableObject:
	if not prefab: return null
	if not prefab.can_instantiate(): return null
	var object := prefab.instantiate()
	if object is not MapInteractableObject:
		push_error("Provided scene is not a MapInteractableObject")
		object.free()
		return null
	var interactable: MapInteractableObject = object
	
	# coordinates must be set before calling add_child() because objects determine
	# their map coordinates from global_position when entering the tree.
	interactable.global_position = map.get_global_coords(coords)
	# MapObjectManager is a plain Node, it doesn't have transform or position,
	# so assigning objects as children won't inadvertently relocate them.
	add_child(interactable)
	
	return object
