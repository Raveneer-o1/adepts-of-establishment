class_name HeroAbility_Setup
extends HeroAbility

@export var starting_leadership := 3

func _learn(hero: HeroData) -> void:
	if not hero.leading_party:
		push_error("Hero %s is not leading a party" % hero.unit_name)
		return
	hero.leading_party.parameters.default_capacity = starting_leadership + 1
