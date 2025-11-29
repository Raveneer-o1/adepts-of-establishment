@abstract
class_name MapInteractableObject
extends Node2D

var map: Map

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
