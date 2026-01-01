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
##     var chosen_tile := choose_tile()
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

## Pauses the entire game except controler. Useful for UI prompts.
func gloabal_pause() -> void:
	if not controller: return
	# shouldn't be necessary, just in case
	controller.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

## Resumes the game.
func gloabal_unpause() -> void:
	get_tree().paused = false

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not game:
		if next_parent is GameMap: game = next_parent
		else: next_parent = next_parent.get_parent()
	if not game:
		push_error("Unable to find GameMap!")
		queue_free()
		return

## This method does not verify if the new unit will belong to this faction:
## it depends on [param container] and this is the job of a caller
func hire_unit(unit_name: StringName, container: Node) -> UnitData:
	var unit_dict: Dictionary = GlobalDefs.database_path.database.get(unit_name, {})
	if not unit_dict: return null
	var cost: Dictionary = unit_dict.get(&"cost", {})
	if this_faction.resource_container.spend(ResourceCost.from_dict(cost)):
		return game.spawn_new_unit(unit_name, container)
	return null
