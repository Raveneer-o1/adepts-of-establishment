class_name UI_UnitPanel_AttackPanel_Effects
extends GridContainer

const ATTACK_EFFECTS_EFFECT_PANEL = preload("uid://dv6rhlj3ijuya")

func fill_effects(effects: Dictionary[String, Variant]) -> void:
	for c in get_children():
		c.queue_free()
	for e in effects:
		var path := e.to_lower()
		if not FileAccess.file_exists(path):
			path = "res://Combat/Effects/AppliedEffects/Scenes/%s.tscn" % e.to_lower()
		if not FileAccess.file_exists(path): 
			push_error("Unknown effect '%s'" % e.to_lower())
			continue
		var sc: AppliedEffect = load(path).instantiate()
		sc.read_params(effects[e])
		if not sc.description: sc.queue_free(); continue
		if sc.effect_name == "Undefined": sc.effect_name = e.capitalize()
		
		var eff: UI_UnitPanel_AttackPanel_Effects_EffectPanel = ATTACK_EFFECTS_EFFECT_PANEL.instantiate()
		add_child(eff)
		eff.add_child(sc)
		eff.set_effect(sc)
