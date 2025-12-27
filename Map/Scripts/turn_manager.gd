class_name MapTurnManager
extends Node

@onready var game: GameMap = $".."

var active_faction: MapFaction
var active_faction_index: int
@onready var factions: Array[MapFaction]

var currnt_day: int = 0
#var _faction_turn: int = 0:
	#get: return _faction_turn
	#set(value):
		#if value >= factions_in_game:
			#currnt_turn += 1
			#_faction_turn = 0
			#return
		#_faction_turn = value

func _next_faction() -> MapFaction:
	var s := factions.size()
	if s == 0: return null
	active_faction_index += 1
	if active_faction_index >= s :
		active_faction_index = 0 
		currnt_day += 1
	
	return factions[active_faction_index]

func next_turn() -> void:
	EventBus.map_turn_ended.emit(active_faction)
	active_faction = null
	active_faction = _next_faction()
	if not active_faction: return
	EventBus.map_turn_started.emit(active_faction)
	active_faction.api.turn_started.emit()

func request_turn_end() -> void:
	await game.current_map.abort_actions()
	if active_faction: active_faction.api.end_turn_clicked.emit()

func _ready() -> void:
	factions.assign($"../Factions".get_children())
