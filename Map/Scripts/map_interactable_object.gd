@abstract
class_name MapInteractableObject
extends Node2D

## Abstract base class for all interactive objects on the map.
##
## Instances of this class should not be freed during runtime. If you need to 
## remove a MapInteractableObject, consider these alternatives: [br]
## - Preserve the object and store its data elsewhere. For example: defeated parties
## can generate graves that store the party data as child nodes 
## [i](for future future resurrection or statistic gathering)[/i]. [br]
## - Utilize the object layer system. [MapObjectsLayer] provides management wrappers
## (see [method MapObjectsLayer.set_tile]) that handle object lifecycle automatically.
## This approach suits disposable objects like treasure bags that disappear when collected.
## [br][br]
## If neither alternative works and object removal is necessary, do not use
## [method queue_free] directly since map nodes maintain references to all
## MapInteractableObject instances. Instead, use [method Map.free_map_object].
## [br][br]
## [MapInteractableObject] automatically locates the [Map] node by traversing
## the scene tree upward. If no Map node is found (reaching the root),
## an error is generated and the object is freed.

var map: Map
var object_name: String = ""

var tile_position: Vector2i:
	get: return tile_position
	set(value):
		if not map:
			push_error("Map reference is empty!")
			tile_position = value
			return
		var mapping_array: Array[MapInteractableObject]
		mapping_array.assign(map.tile_to_object.get(tile_position, []))
		mapping_array.erase(self)
		if map.tile_to_object.has(value):
			map.tile_to_object[value].append(self)
		else:
			map.tile_to_object[value] = [self]
		tile_position = value

@abstract func interact(party: MapParty) -> void
## Determines whether interaction with this object is currently available.
## Returns [code]true[/code] if the tile should highlight as interactable
## when the player hovers over this object with a party selected. [br][br]
## [b]Note:[/b] This method checks interaction availability for the [b]party[/b],
## not the player. For player interaction checks, use [method request_player_interaction].
@abstract func request_interaction(party: MapParty) -> bool
@abstract func passable(party: MapParty) -> bool
#@abstract func click_response(active_faction: MapFaction) -> void

@abstract func request_player_interaction(faction: MapFaction) -> bool
@abstract func player_interact(faction: MapFaction) -> void

func _register_object() -> void:
	tile_position = map.objects_layer.local_to_map(
		map.objects_layer.to_local(global_position)
	)

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map for object '%s'" % object_name)
		queue_free()
		return
	call_deferred(&"_register_object")
