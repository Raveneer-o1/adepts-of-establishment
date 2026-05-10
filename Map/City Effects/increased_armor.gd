extends MapCityEffect

#const BEHIND_WALLS = preload("uid://d0ou87tmajk5v")
const EFFECT_NAME = "behind_walls"
@export var armor_increase: int = 10

func apply_to_combat(combat: CombatSystem) -> void:
	# apply_effect() will be called during initialization
	for u in combat.right_party.all_units:
		u.parameters.apply_effect.call_deferred(
			EFFECT_NAME,
			armor_increase
		)
