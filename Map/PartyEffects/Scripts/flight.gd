extends PartyEffect

@export var fixed_cost := 2

func modify_cost(data: TileData) -> void:
	party_parameters.accumulated_value = fixed_cost

func test() -> void:
	party_parameters.accumulated_value = 0

func  _apply_effect() -> void:
	if not party_parameters.movement_cost_requested.is_connected(modify_cost):
		party_parameters.movement_cost_requested.connect(modify_cost)
	
	# WARNING: test case
	if not party_parameters.movement_multiplier_requested.is_connected(test):
		party_parameters.movement_multiplier_requested.connect(test)
