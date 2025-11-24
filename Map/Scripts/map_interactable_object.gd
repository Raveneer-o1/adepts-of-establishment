@abstract
class_name  MapInteractableObject
extends Node2D

var tile_position: Vector2i

@abstract func interact(party: MapParty) -> void
@abstract func request_interaction(party: MapParty) -> bool
#@abstract func click_response(active_faction: MapFaction) -> void
