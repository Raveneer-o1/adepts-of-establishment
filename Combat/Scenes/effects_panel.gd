class_name UI_UnitPanel_Effects
extends GridContainer

const ATTACK_EFFECTS_EFFECT_PANEL = preload("uid://dv6rhlj3ijuya")

func fill_effects(effects: Array[AppliedEffect]) -> void:
	for c in get_children():
		c.queue_free()
	for e in effects:
		if not e: continue
		var eff: UI_UnitPanel_AttackPanel_Effects_EffectPanel = ATTACK_EFFECTS_EFFECT_PANEL.instantiate()
		add_child(eff)
		eff.set_effect(e)
