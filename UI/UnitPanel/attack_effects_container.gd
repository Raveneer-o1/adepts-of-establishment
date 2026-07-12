class_name UI_UnitPanel_AttackPanel_Effects
extends GridContainer

const ATTACK_EFFECTS_EFFECT_PANEL = preload("uid://dv6rhlj3ijuya")

func fill_effects(effects: Dictionary[String, Variant]) -> void:
	for e in effects:
		var path := e
		if not FileAccess.file_exists(path):
			path = "res://Combat/Effects/AppliedEffects/Scenes/%s.tscn" % e
		if not FileAccess.file_exists(path): 
			push_error("Unlnown effect '%s'" % e)
			continue
		var sc: AppliedEffect = load(path).instantiate()
		sc._apply_effect(effects[e])
		print(sc.get_description())
		
