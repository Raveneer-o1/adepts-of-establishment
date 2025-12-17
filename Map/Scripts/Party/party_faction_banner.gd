class_name PartyFactionBanner
extends Node

func set_color(faction: MapFaction) -> void:
	# TODO: replace with color
	get_child(faction.main_color).show()
