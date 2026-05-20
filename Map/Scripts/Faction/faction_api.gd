class_name FactionAPI
extends Node

## Provides the standardized interface for [FactionController]
## objects to interact with the map.
##
## Similar to [PlayerAPI] which standardizes combat interactions, this class
## offers functions and signals needed for map-based operations.

var map: Map:
	get: return game.current_map
var game: GameMap

@onready var this_faction: MapFaction = $".."
## Returns [code]null[/code] if [member GameMap.screen_player] is not this faction.
## This node contains UI input signals and functions that remain disconnected
## by default, preventing UI operation without explicit controller setup.
## This safeguards against UI bugs that could allow unauthorized state manipulation
## (e.g., hiring units for other players) since UI does not
## (and should not) check for permissions.
var ui_filter: API_UIFilter:
	get:
		if not game: return null
		return _ui_filter if game.screen_player == this_faction else null
@onready var _ui_filter: API_UIFilter = API_UIFilter.new()

## The controller managing this faction. Controller is the node responsible
## for all actions through this API.
var controller: FactionController = null

## Processes a tile selected by player or AI input. This differs from
## [signal tile_clicked], which is emitted when an actual click occurs.
## This method initiates tile processing, while [signal tile_clicked]
## signals the click event. [br]
## [b]Note:[/b] This function filters UI interactions, so AI can't "click"
## on objects to select them. Use dedicated functions for object choosing
## (e.g., [method try_choose_party]).
## [br][br]
## Example implementation for player interaction:
## [codeblock]
## func process_click(tile: Vector2i) -> void:
##     api.choose_tile(tile)
##
## func initialize() -> void:
##     api.tile_clicked.connect(process_click)
## [/codeblock]
##
## Example for AI decision-making:
## [codeblock]
## # AI ignores tile_clicked signal as it doesn't need to react to player's clicks
##
## func make_decision() -> void:
##     var chosen_tile := _choose_tile()
##     api.choose_tile(chosen_tile)
## [/codeblock]
## [b]Note:[/b] Mouse hover interactions are not handled through this API.
## See [MapEventHandler] for hover processing.
func choose_tile(tile: Vector2i) -> void:
	if not map: return
	await map.player_act(tile, this_faction)

func try_choose_party(party: MapParty) -> bool:
	if party.object_owner != this_faction: return false
	map.set_active_party(party)
	return true

## Emitted by the system when the player clicks a tile. This differs from
## [method choose_tile], which processes the selected tile. [br][br]
## This signal triggers controller logic in response to player input.
## Controllers listen for this signal and should not emit it.
signal tile_clicked(tile: Vector2i)

## Emitted when this faction's turn begins. Mirrors [signal EventBus.map_turn_started]
## to avoid controller dependency on game structure - controllers should interact
## exclusively through the API.
signal turn_started

## Emitted when end of turn button is clicked by player.
## The turn is not ended when the signal is emitted, it is the responsibility of
## the controller to call [method end_turn].
signal end_turn_clicked

## Ends the turn on the map
func end_turn() -> void:
	game.turn_manager.next_turn()

## Enables player input processing for human-controlled factions.
## Should only be called by controllers representing human players.
## This permits the game to emit [signal tile_clicked] when players click tiles.
func access_player_input() -> void:
	map.event_handler.allow_game_access()

## Sets this faction as the screen-player.
## This allows UI to adapt and show only information allowed.
func set_player_at_screen() -> void:
	game.screen_player = this_faction

## Requests the [member controller] to select an evolution path for
## [param unit] from [param options].
## If no controller is present, picks at random.
func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName:
	if not controller: return options.pick_random()
	@warning_ignore("redundant_await")
	return await controller.choose_evolution(unit, options)

## Requests the [member controller] to select an ability
## [param hero] from [param options].
## If no controller is present, picks at random.
## Can be asynchronous (use [code]await[/code]).
func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility:
	@warning_ignore("redundant_await")
	if controller: return await controller.choose_hero_ability(hero, options)
	return options.pick_random()

## Pauses the entire game except controler. Useful for UI prompts.
func global_pause() -> void:
	if not controller: return
	# shouldn't be necessary, just in case
	controller.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

## Resumes the game.
func global_unpause() -> void:
	get_tree().paused = false

func _ready() -> void:
	add_child(_ui_filter, false, Node.INTERNAL_MODE_FRONT)
	var next_parent := get_parent()
	while next_parent and not game:
		if next_parent is GameMap: game = next_parent
		else: next_parent = next_parent.get_parent()
	if not game:
		push_error("Unable to find GameMap!")
		queue_free()
		return

func _verify_ownership(container: Node) -> bool:
	while container:
		if container is MapInteractableObject:
			return container.object_owner == this_faction
		if container is MapFaction:
			return container == this_faction
		container = null if container is Map else container.get_parent()
	return false

## Creates and initializes a new unit using this faction's resources.
## Generates a [UnitData] node, adds it to [param container], initializes
## with defaults for [param unit_name], and returns the new object. [br]
## Returns [code]null[/code] on failure
## (e.g., incorrect faction or container or insufficient resources).
func hire_unit(unit_name: StringName, container: UnitsContainer) -> UnitData:
	var unit_dict: Dictionary = GlobalDefs.units_database.database.get(unit_name, {})
	if not unit_dict: return null
	if not _verify_ownership(container):
		push_error("Failed verification for hiring unit")
		return null
	var cost: Dictionary = unit_dict.get(&"cost", {})
	if this_faction.resource_container.spend(ResourceCost.from_dict(cost)):
		var unit := game.spawn_new_unit(unit_name, container)
		if unit: EventBus.unit_hired.emit(unit)
		return unit
	return null

## Returns if the provided [param upgrade] can be researched right now.
func can_be_researched(upgrade: FactionUpgrade) -> bool:
	if not upgrade: return false
	if not upgrade.can_be_researched(): return false
	if not _verify_ownership(upgrade):
		push_error("Failed verification for researching upgrade")
		return false
	return this_faction.resource_container.can_spend(upgrade.cost)

## Researches specified [param upgrade]. Returns if successful.
func research(upgrade: FactionUpgrade) -> bool:
	if not can_be_researched(upgrade): return false
	if not this_faction.resource_container.spend(upgrade.cost): return false
	this_faction.research(upgrade)
	return true

## Returns all interactable objects present on the specified tile coordinates in [param list].
## When [param party] is provided, results are filtered to objects that can interact
## with that party, and the default map is set to the party's current map,
## unless a specific [param _map] is provided.
## Otherwise, uses [member GameMap.current_map] by default,
## unless a specific [param _map] is provided.[br]
## If [param exclude_occupied_city] is [code]true[/code], 
## the result does not include the city the party currently occupies.
func get_interactions(
	list: Array[Vector2i],
	party: MapParty = null,
	_map: Map = null,
	exclude_occupied_city := true,
) -> Array[MapInteractableObject]:
	if not list: return []
	if not _map: _map = party.map if party else game.current_map
	var result: Dictionary = {}
	for tile in list:
		for o: MapInteractableObject in _map.tile_to_interaction.get(tile, []):
			if o in result: continue
			if party and exclude_occupied_city and o == party.inside_city: continue
			if not party or o.can_interact(party):
				# null value doesn't mean anything, 
				# it's a placeholder for the hashmap
				result[o] = null
	var res: Array[MapInteractableObject] = []
	res.assign(result.keys())
	return res

## Returns all tiles the [param party] is able ro reach right now.
func get_reachable_tiles(party: MapParty) -> Array[Vector2i]:
	if not party: return []
	return party.map.path_finder.get_all_tiles(
		party.tile_position,
		party.parameters.movement_points,
		TravelData.new(party)
	)

## Attempts to move [param unit] to the specified [param destination] container.
## Returns [code]true[/code] if the move is permitted.
## If [param destination] is the container currently storing the unit
## or [code]null[/code], the move is treated as identity and always succeeds.
func move_unit(unit: UnitData, destination: UnitsContainer, position: int) -> bool:
	# TODO: check for position on map
	if not _move_unit(unit, destination): return false
	unit.party_position = position
	return true

func _move_unit(unit: UnitData, destination: UnitsContainer) -> bool:
	if not destination: return true
	if not unit: return false
	assert(unit.container, "Unit is not inside a container")
	if not unit.container.try_transfer_unit(unit, destination): return false
	#unit.reparent(destination)
	return true

## Creates a new [MapParty] at [param coords] on the specified [param _map]
## (defaults to current active map). Optionally adds a hero unit
## if [param hero_name] is provided.
func hire_party(coords: Vector2i, _map: Map = map, hero_name: StringName = &"") -> MapParty:
	var hero_dict: Dictionary = GlobalDefs.units_database.database.get(hero_name, {})
	var cost: Dictionary = hero_dict.get(&"cost", MapParty.DEFAULT_PARTY_COST)
	if not this_faction.resource_container.spend(ResourceCost.from_dict(cost)):
		return null
	
	var party := await game.spawn_new_party(coords, this_faction, _map)
	if not party: return null
	if hero_name:
		var hired_hero: UnitData = game.spawn_new_unit(hero_name, party.units_container)
		if hired_hero is HeroData:
			party.hero = hired_hero
	EventBus.party_hired.emit(party)
	return party

func transfer_unit(unit: UnitData, container: UnitsContainer) -> void:
	if not container: return
	if not unit: return
	
	if not unit.container.can_transfer(container): return
	
	unit.container.try_transfer_unit(unit, container)

#region Mirrors
## Returns all [FactionUpgrade] nodes available for research.
## Excludes [UnitEvolution] nodes by default. Set [param include_evolution_buildings]
## to [code]true[/code] to include evolution upgrades.
func get_available_research(include_evolution_buildings := false) -> Array[FactionUpgrade]:
	return this_faction.get_available_upgrades(include_evolution_buildings)

## Returns all parties owned by this faction.
## If [param only_active_map] is [code]false[/code], searches across all maps in the game.
## Otherwise, only the currently active map is considered.
func get_available_parties(only_active_map := false) -> Array[MapParty]:
	return this_faction.get_available_parties(only_active_map)

## Returns the list of all heroes available for hiring
func get_heroes_list() -> Array[StringName]:
	return this_faction.hiring_heroes
#endregion
