extends FactionController

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	return options.pick_random()

func _initialize() -> void:
	api.turn_started.connect(
		func()->void: api.end_turn()
	)
