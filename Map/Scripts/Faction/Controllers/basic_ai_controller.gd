extends FactionController

const START_TURN_DELAY = 0.5
const END_TURN_DELAY = 0.15

func _end_turn() -> void:
	await get_tree().create_timer(END_TURN_DELAY).timeout
	api.end_turn()

func _control_party(current_party: MapParty) -> void:
	if not current_party: return
	if not api.try_choose_party(current_party):
		push_error("Unable to choose a party %s" % current_party.object_name)
		return
	
	var all_coords := api.get_reachable_tiles(current_party)
	var all_interactions := api.get_interactions(all_coords, current_party)
	var target: Vector2i = \
		(all_interactions.pick_random() as MapInteractableObject).tile_position \
		if all_interactions else all_coords.pick_random()
	await api.choose_tile(target)

func _make_building() -> void:
	var all_buildings := api.get_available_research(true)
	for b in all_buildings:
		if api.research(b): break

func _choose_hero() -> StringName:
	var all_heros := api.get_heroes_list()
	if all_heros: return all_heros.pick_random()
	return &""

func _optimize_party(party: MapParty) -> void:
	if not party: return
	# TODO: write a function to rearrange unit positions
	# and take units from a city if need be
	
	var unit := _decide_and_hire_unit(party.inside_city)
	if not unit: return
	api.transfer_unit(unit, party.units_container)
	unit.party_position = 2

func _hire_party(city: MapCity) -> MapParty:
	if not city: return null
	var new_party := await api.hire_party(city.tile_position, city.map, _choose_hero())
	if not new_party: return null
	
	_optimize_party(new_party)
	return new_party

func _choose_unit_to_hire(city: MapCity) -> StringName:
	var all_units := city.get_available_units()
	return all_units.pick_random() if all_units else &""

func _hire_unit(city: MapCity, unit: StringName) -> UnitData:
	if not city or not unit: return null
	return api.hire_unit(unit, city.units_container)

func _decide_and_hire_unit(city: MapCity) -> UnitData:
	if not city: return null
	var unit := _choose_unit_to_hire(city)
	if not unit: return null
	return _hire_unit(city, unit)

func _map_cycle() -> void:
	await get_tree().create_timer(START_TURN_DELAY).timeout
	_make_building()
	
	# TODO: implement decision making on where to hire the party
	await _hire_party(api.this_faction.capital)
	
	var all_parties := api.get_available_parties()
	for current_party in all_parties:
		await _control_party(current_party)
	_end_turn()

func  _initialize() -> void:
	api.turn_started.connect(_map_cycle)

func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	return options.pick_random()

func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	return options.pick_random()
