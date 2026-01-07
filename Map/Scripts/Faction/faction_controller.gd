@abstract
class_name FactionController
extends Node

var api: FactionAPI

@abstract func _initialize() -> void
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
