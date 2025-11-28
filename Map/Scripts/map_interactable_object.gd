@abstract
class_name MapInteractableObject
extends Node2D

var tile_position: Vector2i

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
