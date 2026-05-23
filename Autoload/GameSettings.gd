extends Node

var player_party_speed := 5.0
var AI_party_speed := 10.0

var enable_fog_of_war: bool = true:
	get: return (not OS.is_debug_build()) or enable_fog_of_war
	set(value): enable_fog_of_war = value

var safe_travel: bool = true
signal show_tile_ownership_changed
var show_tile_ownership: bool = false:
	get: return show_tile_ownership
	set(value):
		if value == show_tile_ownership: return
		show_tile_ownership = value
		show_tile_ownership_changed.emit()
