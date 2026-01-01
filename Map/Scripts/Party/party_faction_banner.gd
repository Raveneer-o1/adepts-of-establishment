class_name PartyFactionBanner
extends Node

func set_color(faction: MapFaction) -> void:
	# FIXME: replace with color
	if faction:
		get_child(faction.main_color).show()
