class_name UI_UnitPanel_AttackPanel_Effects
extends GridContainer

const ATTACK_EFFECTS_EFFECT_PANEL = preload("uid://dv6rhlj3ijuya")

func fill_effects(effects: Dictionary[String, Variant]) -> void:
	for c in get_children():
		c.queue_free()
	for e in effects:
		var path := e
		if not FileAccess.file_exists(path):
			path = "res://Combat/Effects/AppliedEffects/Scenes/%s.tscn" % e
		if not FileAccess.file_exists(path): 
			push_error("Unlnown effect '%s'" % e)
			continue
		var sc: AppliedEffect = load(path).instantiate()
		sc.read_params(effects[e])
		
		var eff: UI_UnitPanel_AttackPanel_Effects_EffectPanel = ATTACK_EFFECTS_EFFECT_PANEL.instantiate()
		add_child(eff)
		eff.set_effect(sc)
