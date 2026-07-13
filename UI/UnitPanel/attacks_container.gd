class_name UI_UnitPanel_AttacksContainer
extends ScrollContainer

const ATTACK_PANEL = preload("uid://cn26iuo3vxrgy")
@onready var h_box_container: HBoxContainer = $HBoxContainer

func fill_attacks(a: Array) -> void:
	for ch in h_box_container.get_children():
		if ch is UI_UnitPanel_AttackPanel: ch.queue_free()
	for atk: Variant in a:
		if atk is not UnitAttack:
			if atk is not UnitAttackData:
				push_error("Unexpected type")
				continue
		var obj: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
		h_box_container.add_child(obj)
		obj.fill_data(atk)
