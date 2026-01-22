extends PartyEffect

@export var fixed_cost := 1

func _apply_effect(...args: Array) -> void:
	# Effect: fixed cost for water tiles
	party_parameters.movement_cost_requested.connect(modify_cost)

	# Effect: double movement cost for all tiles
	party_parameters.movement_multiplier_requested.connect(modify_multiplier)

	# Combined effect: double all costs, except water which costs 1

func modify_cost(data: TileData) -> void:
	if data.get_custom_data("tile_type") == &"water":
		party_parameters.accumulated_value = fixed_cost

func modify_multiplier() -> void:
	party_parameters.accumulated_value = 2
