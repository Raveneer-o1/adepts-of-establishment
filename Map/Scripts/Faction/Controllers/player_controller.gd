extends FactionController

func turn_start_reaction() -> void:
	api.access_player_input()
	api.set_player_at_screen()

func _initialize() -> void:
	api.tile_clicked.connect(api.choose_tile)
	api.end_turn_clicked.connect(api.end_turn)
	api.turn_started.connect(turn_start_reaction)
