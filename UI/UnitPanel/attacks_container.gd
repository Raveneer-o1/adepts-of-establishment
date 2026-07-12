class_name UI_UnitPanel_AttacksContainer
extends HBoxContainer

const ATTACK_PANEL = preload("uid://cn26iuo3vxrgy")

func fill_attacks(a: Array) -> void:
	for c in get_children():
		c.queue_free()
	for atk: Variant in a:
		if atk is not UnitAttack:
			if atk is not UnitAttackData:
				push_error("Unexpected type")
				continue
		var obj: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
		add_child(obj)
		obj.fill_data(atk)
