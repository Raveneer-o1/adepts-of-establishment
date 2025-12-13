class_name MapTurnManager
extends Node

@onready var game: GameMap = $".."

var active_faction: MapFaction
var active_faction_index: int
@onready var factions: Array[MapFaction]

func _next_faction() -> MapFaction:
	var s := factions.size()
	if s == 0: return null
	active_faction_index = 0 \
		if active_faction_index + 1 >= s \
		else active_faction_index + 1
	return factions[active_faction_index]

func next_turn() -> void:
	EventBus.map_turn_ended.emit(active_faction)
	active_faction = null
	active_faction = _next_faction()
	if not active_faction: return
	EventBus.map_turn_started.emit(active_faction)
	active_faction.api.turn_started.emit()

func _ready() -> void:
	factions.assign($"../Factions".get_children())
