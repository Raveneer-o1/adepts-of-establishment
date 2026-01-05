class_name PartyFactionBanner
extends Node

@onready var white_banner: AnimatedSprite2D = $white

func set_color(faction: MapFaction) -> void:
	if faction:
		white_banner.self_modulate = faction.main_color
		white_banner.show()
	else: white_banner.hide()
