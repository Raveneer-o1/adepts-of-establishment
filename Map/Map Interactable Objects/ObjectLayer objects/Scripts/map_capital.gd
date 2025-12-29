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

#func request_player_interaction(faction: MapFaction) -> bool:
	#return faction == object_owner
#
#func player_interact(faction: MapFaction) -> void:
	#_request_switching()

#endregion
