extends AppliedEffect

@export var hp_increase: int = 50

## Called when the effect is applied to a unit.
func _apply_effect() -> void:
	var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	for unit in affected_units:
		unit.parameters.add_modifier(
				"max_HP", 
				self, 
				func(hp): return hp + hp_increase
		)
