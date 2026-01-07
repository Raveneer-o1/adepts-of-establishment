extends FactionController

func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	return options.pick_random()

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	return options.pick_random()

func _initialize() -> void:
	api.turn_started.connect(
		func()->void:
			await get_tree().create_timer(0.5).timeout
			api.end_turn()
	)
