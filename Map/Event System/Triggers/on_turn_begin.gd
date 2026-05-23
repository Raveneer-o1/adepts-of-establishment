class_name MapTrigger_OnTurnBegin
extends MapTrigger

## The turn number on which the trigger should activate.
## If [code]0[/code], only activated on the first turn, before everything else.
## If [member one_time] is [code]false[/code], the trigger will activate
## every [b]day[/b] turns.
@export var day := 1
@onready var _day_step := day

## What faction should is concidered for this trigger
@export var faction_index := -1

var _faction: MapFaction

func _check_trigger(faction: MapFaction) -> void:
	if not active: return
	while day < _map.game.turn_manager.currnt_day: day += _day_step
	if _map.game.turn_manager.currnt_day != day: return
	if _faction and faction != _faction: return
	trigger()

func _initialize() -> void:
	if _day_step < 0:
		push_error("Negative day")
		queue_free()
		return
	_faction = _map.game.get_faction(faction_index)
	if day == 0:
		EventBus.first_map_turn_started.connect(_check_trigger)
		return
	EventBus.map_turn_started.connect(_check_trigger)
