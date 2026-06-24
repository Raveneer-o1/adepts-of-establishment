@abstract
class_name FactionController
extends Node

## The node responsible for decision‑making and translating actions into
## [FactionAPI] calls.
##
## [b]Important:[/b] Controller nodes are considered trusted components with full
## access to the game state and underlying system. This implies that:[br]
## [b]First[/b], controllers must support multiplayer security, as connections
## will be established via specialized controllers (e.g., [i]multiplayer_host[/i]
## and [i]multiplayer_client[/i]);[br]
## [b]Second[/b], errors within a controller can cause unintended behavior despite
## the limited safeguards present in [FactionAPI]. This is intentional — controllers
## are internal game components, not external systems. For external integrations,
## controllers must implement a secure API layer.

var api: FactionAPI

@abstract func _initialize() -> void

# TODO: redesign this. it should be invoked even with a single evolution path as
# the player might want to not evolve the unit
## Selects an evolutionary path from available options for the specified unit.
## Can be asynchronous (use [code]await[/code]).
## Not invoked when only one evolutionary option available.
@abstract func choose_evolution(unit: UnitData, options: Array[StringName]) -> StringName
@abstract func choose_hero_ability(hero: HeroData, options: Array[HeroAbility]) -> HeroAbility


func _ready() -> void:
	var parent := get_parent()
	if parent is not FactionAPI:
		push_error("FactionController object must be a child of FactionAPI node!")
		queue_free()
		return
	api = parent
	api.controller = self
	_initialize()
