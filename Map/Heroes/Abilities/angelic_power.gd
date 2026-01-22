extends HeroAbility

@export var additional_uses := 1
const EFFECT_NAME = "Divine nature"

func _learn(hero: HeroData) -> void:
	for e in hero.effects:
		if e[&"effect_name"] != EFFECT_NAME: continue
		assert(e[&"args"] is Array)
		assert(not e[&"args"].is_empty())
		assert(e[&"args"][0] is int)
		e[&"args"][0] += additional_uses
		return
	push_error("%s effect is not found" % EFFECT_NAME)
