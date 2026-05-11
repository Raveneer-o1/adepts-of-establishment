extends FactionController

const START_TURN_DELAY = 0.5
const END_TURN_DELAY = 0.15

func _end_turn() -> void:
	await get_tree().create_timer(END_TURN_DELAY).timeout
	api.end_turn()

func _make_map_decision() -> void:
	await get_tree().create_timer(START_TURN_DELAY).timeout
	var all_parties := api.get_available_parties()
	var current_party: MapParty = all_parties.pick_random()
	if not api.try_choose_party(current_party): api.end_turn()
	#api.choose_tile(current_party.tile_position)
	await api.choose_tile(current_party.tile_position + Vector2i(5, 0))
	
	_end_turn()

func  _initialize() -> void:
	api.turn_started.connect(_make_map_decision)

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	return options.pick_random()

func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	return options.pick_random()
