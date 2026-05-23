class_name MapTurnManager
extends Node

@onready var game: GameMap = $".."

var active_faction: MapFaction
var active_faction_index: int
@onready var factions: Array[MapFaction]

## A day is ended when all factions had one turn
## (i.e., a day is a full cycle of all factions' turns).
var currnt_day: int = 0

func _next_faction() -> MapFaction:
	var s := factions.size()
	if s == 0: return null
	active_faction_index += 1
	if active_faction_index >= s :
		active_faction_index = 0 
		currnt_day += 1
	
	return factions[active_faction_index]

## Proceeds to the text global turn, giving the game control to the next faction.
func next_turn() -> void:
	EventBus.map_turn_ended.emit(active_faction)
	active_faction = null
	active_faction = _next_faction()
	if not active_faction: return
	(
		EventBus.first_map_turn_started if currnt_day == 0 \
		else EventBus.map_turn_started\
	).emit(active_faction)
	active_faction.api.turn_started.emit()

## Emits [signal FactionAPI.end_turn_clicked] for the current faction.
## This transmits the end-turn request but does not force turn end.
func request_turn_end() -> void:
	await game.current_map.abort_actions()
	if active_faction: active_faction.api.end_turn_clicked.emit()

func _ready() -> void:
	factions.assign($"../Factions".get_children())
