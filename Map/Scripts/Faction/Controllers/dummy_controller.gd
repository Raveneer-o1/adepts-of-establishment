extends FactionController

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	return options.pick_random()

func _initialize() -> void:
	api.turn_started.connect(
		func()->void:
			var timer := get_tree().create_timer(0.5)
			await timer.timeout
			api.end_turn()
	)
