extends AppliedEffect

@export var armor_increase: int = 5

## Called when the effect is applied to a unit.
func _apply_effect() -> void:
	var affected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	for unit in affected_units:
		unit.parameters.add_modifier(
				"armor", 
				self, 
				func(armor): return armor + armor_increase
		)
