extends Node

var player_party_speed := 5.0
var AI_party_speed := 10.0

var safe_travel: bool = true
signal show_tile_ownership_changed
var show_tile_ownership: bool = false:
	get: return show_tile_ownership
	set(value):
		if value == show_tile_ownership: return
		show_tile_ownership = value
		show_tile_ownership_changed.emit()
