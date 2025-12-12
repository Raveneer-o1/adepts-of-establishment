extends FactionController

func _initialize() -> void:
	api.tile_clicked.connect(api.choose_tile)
