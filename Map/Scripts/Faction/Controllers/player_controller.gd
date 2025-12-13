extends FactionController

func turn_start_reaction() -> void:
	api.access_player_input()

func _initialize() -> void:
	api.tile_clicked.connect(api.choose_tile)
	api.turn_started.connect(turn_start_reaction)
