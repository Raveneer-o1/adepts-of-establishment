class_name MapCapital
extends MapCity


func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	return [
		main,
		main + Vector2i(1, 0),
		main + Vector2i(-1, 0),
		main + Vector2i(-1, -1),
		main + Vector2i(0, -1),
		main + Vector2i(1, -1),
		main + Vector2i(2, -1),
		main + Vector2i(0, -2),
		main + Vector2i(1, -2),
		main + Vector2i(2, -2),
	]

#region Abstract Implementation

func request_player_interaction(faction: MapFaction) -> bool:
	# Return whether the player can interact with this object
	# Includes actions like selecting active party or opening capital window
	# NOTE: Only handles "left-click" interactions
	#       "right-click" for information and game settings are managed separately
	return false

func player_interact(faction: MapFaction) -> void:
	# Handle player interaction with this object
	# Includes actions like selecting active party or opening capital window
	# NOTE: Only handles "left-click" interactions
	#       "right-click" for information and game settings are managed separately
	return

#endregion
