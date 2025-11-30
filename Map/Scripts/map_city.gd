class_name MapCity
extends MapInteractableObject

func interact(party: MapParty) -> void:
	return

func request_interaction(party: MapParty) -> bool:
	return false

func passable(party: MapParty) -> bool:
	return false

func request_player_interaction(faction: MapFaction) -> bool:
	return false

func player_interact(faction: MapFaction) -> void:
	return
