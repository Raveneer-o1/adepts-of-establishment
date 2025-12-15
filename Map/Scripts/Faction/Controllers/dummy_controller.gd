extends FactionController

func _initialize() -> void:
	api.turn_started.connect(
		func()->void: api.end_turn()
	)
