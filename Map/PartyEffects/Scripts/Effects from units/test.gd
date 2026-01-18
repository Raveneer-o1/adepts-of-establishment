extends PartyEffectFromUnit

func _set_max_mp(tile: TileData) -> void:
	party_parameters.accumulated_value = 0

func _apply_effect(...args: Array) -> void:
	effect_mapping[party_parameters.movement_cost_requested] = _set_max_mp
