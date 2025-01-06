extends AppliedEffect

@export var damage_pet_turn: int = 30

func deal_damage(unit: Unit) -> void:
	if unit == target_unit:
		target_unit.take_direct_damage(damage_pet_turn, "poison")

## Called when the effect is applied to a unit.
func _apply_effect() -> void:
	EventBus.turn_started.connect(deal_damage)
