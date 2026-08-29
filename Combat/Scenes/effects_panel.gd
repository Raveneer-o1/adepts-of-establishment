class_name UI_UnitPanel_Effects
extends FlowContainer

const ATTACK_EFFECTS_EFFECT_PANEL = preload("uid://dv6rhlj3ijuya")

func fill_effects(effects: Array[AppliedEffect]) -> void:
	for c in get_children():
		c.queue_free()
	for e in effects:
		if not e: continue
		var eff: UI_UnitPanel_AttackPanel_Effects_EffectPanel = ATTACK_EFFECTS_EFFECT_PANEL.instantiate()
		add_child(eff)
		eff.set_effect(e)

#{
	#&"effect_name": String,
	#&"effect_path": String,
	#&"args": Variant,
#}
func fill_effects_data(effects: Array[Dictionary]) -> void:
	for c in get_children():
		c.queue_free()
	for e in effects:
		var path : String = e.get("effect_path", "")
		if not FileAccess.file_exists(path): 
			push_error("Unknown effect '%s'" % e.get("effect_name", "?"))
			continue
		var sc: AppliedEffect = load(path).instantiate()
		sc.read_params(e.get("args"))
		sc.effect_name = e.get("effect_name", sc.effect_name)
		
		var eff: UI_UnitPanel_AttackPanel_Effects_EffectPanel = ATTACK_EFFECTS_EFFECT_PANEL.instantiate()
		add_child(eff)
		eff.add_child(sc)
		eff.set_effect(sc)
