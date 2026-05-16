class_name MapCapital
extends MapCity

@export var gold_income := 50
@export var stone_income := 10
@export var mana_income := 0

func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	return [
		main,
		main + Vector2i(1, 0),
		main + Vector2i(-1, 0),
		main + Vector2i(-1, -1),
		main + Vector2i(0, -1),
		main + Vector2i(1, -1),
		main + Vector2i(2, -1),
		main + Vector2i(0, -2),
		main + Vector2i(1, -2),
		main + Vector2i(2, -2),
	]

#region Abstract Implementation

#func _request_player_interaction(faction: MapFaction) -> bool:
	#return faction == object_owner
#
#func _player_interact(faction: MapFaction) -> void:
	#_request_switching()

#endregion

func _provide_income(faction: MapFaction) -> void:
	if not object_owner: return
	if object_owner != faction: return
	object_owner.resource_container.receive_gold(gold_income)
	object_owner.resource_container.receive_stone(stone_income)
	object_owner.resource_container.receive_mana(mana_income)

func _initialize() -> void:
	assert(object_owner)
	assert(not object_owner.capital)
	object_owner.capital = self
	EventBus.map_turn_started.connect(_provide_income)
