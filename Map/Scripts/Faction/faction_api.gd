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
## signals the click event. [br][br]
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
	map.player_act(tile, this_faction)

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

## Researches specified [param upgrade]. Returns if successful.
func research(upgrade: FactionUpgrade) -> bool:
	if not upgrade: return false
	if not upgrade.can_be_researched(): return false
	if not _verify_ownership(upgrade):
		push_error("Failed verification for researching upgrade")
		return false
	if this_faction.resource_container.spend(upgrade.cost):
		this_faction.research(upgrade)
		return true
	return false

## Attempts to move [param unit] to the specified [param destination] container.
## Returns [code]true[/code] if the move is permitted.
## If [param destination] is the container currently storing the unit
## or [code]null[/code], the move is treated as identity and always succeeds.
func move_unit(unit: UnitData, destination: UnitsContainer, position: int) -> bool:
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

# FIXME: move the default cost somewhere else
const DEFAULT_PARTY_COST = {
	&"gold": 100,
	&"stone": 0,
	&"mana": 0,
}

## Creates a new [MapParty] at [param coords] on the specified [param _map]
## (defaults to current active map). Optionally adds a hero unit if [param hero] is provided.
## @experimental: Heros are not properly implemented yet.
func hire_party(coords: Vector2i, _map: Map = map, hero_name: StringName = &"") -> MapParty:
	var hero_dict: Dictionary = GlobalDefs.units_database.database.get(hero_name, {})
	var cost: Dictionary = hero_dict.get(&"cost", DEFAULT_PARTY_COST)
	if not this_faction.resource_container.spend(ResourceCost.from_dict(cost)):
		return null
	
	var party := game.spawn_new_party(coords, _map)
	if not party: return null
	party.object_owner = this_faction
	if hero_name:
		var hired_hero: UnitData = game.spawn_new_unit(hero_name, party.units_container)
		if hired_hero is HeroData:
			party.hero = hired_hero
	return party
