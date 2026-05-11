extends FactionController

const START_TURN_DELAY = 0.5
const END_TURN_DELAY = 0.15

func _end_turn() -> void:
	await get_tree().create_timer(END_TURN_DELAY).timeout
	api.end_turn()

func _make_map_decision() -> void:
	await get_tree().create_timer(START_TURN_DELAY).timeout
	var all_parties := api.get_available_parties()
	for current_party in all_parties:
		if not api.try_choose_party(current_party):
			push_error("Unable to choose a party")
			continue
		
		var all_coords := api.get_reachable_tiles(current_party)
		var all_interactions := api.get_interactions(all_coords, current_party)
		var target: Vector2i = \
			(all_interactions.pick_random() as MapInteractableObject).tile_position \
			if all_interactions else all_coords.pick_random()
		await api.choose_tile(target)
	
	_end_turn()

func  _initialize() -> void:
	api.turn_started.connect(_make_map_decision)

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	return options.pick_random()

func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	return options.pick_random()
