class_name MapCastle
extends MapCity

func get_interaction_tiles(
	party: MapParty = null,
	main: Vector2i = tile_position,
) -> Array[Vector2i]:
	return [
		main + Vector2i(-1, 2),
	]

func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	return [
		main,
		main + Vector2i(0, 1),
		main + Vector2i(-1, 1),
	]

func _initialize() -> void:
	super._initialize()
	# Manually placing the castle sprite is difficult
	# snap it automatically to the grid.
	global_position = map.get_global_coords(tile_position)
