class_name UI_UnitPanel_AttackPanel_Container
extends Control

const ATTACK_PANEL = preload("uid://cn26iuo3vxrgy")
## Should be the same as style margins for the attack panel texture
const MARGINS = Vector2(15.0, 15.0)
const _ACTUAL_MARGINS = MARGINS * 2.0
const CHILDREN_STEP = Vector2(25.0, 5.0)

func fill_data(a: Variant) -> void:
	for ch in get_children():
		if ch is UI_UnitPanel_AttackPanel:
			ch.queue_free()
	if a is UnitAttack: _fill_data_attack(a)
	elif a is UnitAttackData: _fill_data_attack_data(a)
	else: push_error("Unexpected type")

func _fill_data_attack(a: UnitAttack) -> void:
	var current_max_size := Vector2.ZERO
	var current_child := 0
	
	for alt_a in a.get_children():
		if alt_a is not UnitAttack: continue
		current_child += 1
		var alt_obj: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
		add_child(alt_obj)
		alt_obj.fill_data(alt_a)
		alt_obj.position = CHILDREN_STEP * current_child
		current_max_size = alt_obj.position + alt_obj.size
	
	var obj: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
	add_child(obj)
	obj.fill_data(a)
	
	if current_child == 0:
		current_max_size = obj.position + obj.size
	custom_minimum_size = current_max_size + _ACTUAL_MARGINS


func _fill_data_attack_data(a: UnitAttackData) -> void:
	var current_max_size := Vector2.ZERO
	var current_child := 0
	
	for alt_a in a.alternative_actions:
		current_child += 1
		var alt_obj: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
		add_child(alt_obj)
		alt_obj.fill_data(alt_a)
		alt_obj.position = CHILDREN_STEP * current_child
		current_max_size = alt_obj.position + alt_obj.size
	
	var obj: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
	add_child(obj)
	obj.fill_data(a)
	
	if current_child == 0:
		current_max_size = obj.position + obj.size
	custom_minimum_size = current_max_size + _ACTUAL_MARGINS
