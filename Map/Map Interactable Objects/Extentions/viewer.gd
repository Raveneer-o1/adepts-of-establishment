class_name MapViewer
extends Node

## Viewing distance of this object.
@export var radius := 5

## Extra tiles added to the viewing distance, ignoring passability checks.
## For parent objects other than [MapParty],
## it is equivalent to adding the same value directly to [member radius].
@export var padding := 0

@onready var this_object: MapInteractableObject = get_parent()

func _see_land_by_party(party: MapParty) -> void:
	pass


func see_land() -> void:
	if not this_object: return
	await this_object.object_ready
	if not this_object.object_owner: return
	var tiles := this_object.map.path_finder.get_all_tiles(
		this_object.tile_position,
		radius,
		TravelData.new(this_object) if this_object is MapParty else null,
		padding,
		true
	)
	for tile in tiles:
		this_object.map.tile_data_hashmap[tile].set_visibility(this_object.object_owner)

func _ready() -> void:
	this_object.object_modified.connect(see_land)
	this_object.object_changed.connect(see_land)
	see_land.call_deferred()
