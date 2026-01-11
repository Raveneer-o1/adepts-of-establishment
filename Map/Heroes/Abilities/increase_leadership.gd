extends HeroAbility

## Can be negative. Will decrease party capacity in this case.
@export var leadership_increase := 1

func _learn(hero: HeroData) -> void:
	if not hero.leading_party:
		push_error("Hero %s is not leading a party" % hero.unit_name)
		return
	hero.leading_party.parameters.default_capacity += leadership_increase
