class_name UI_UnitPanel_AttackPanel
extends PanelContainer

@onready var damage_label: Label = $MarginContainer/VBoxContainer/DMG_ACC/DamageContainer/Label
@onready var accuracy_label: Label = $MarginContainer/VBoxContainer/DMG_ACC/AccuracyContainer/Label
@onready var initiative_label: Label = $MarginContainer/VBoxContainer/InitiativeContainer/Label
@onready var type_label: Label = $MarginContainer/VBoxContainer/TypeContainer/Label
@onready var attack_effects: UI_UnitPanel_AttackPanel_Effects = $MarginContainer/VBoxContainer/Attack_Effects_GridContainer
@onready var attack_name: Label = $MarginContainer/VBoxContainer/AttackName

func fill_data(a: Variant) -> void:
	if a is UnitAttack: _fill_data_attack(a)
	elif a is UnitAttackData: _fill_data_attack_data(a)
	else: push_error("Unexpected type")

func _fill_data_attack(a: UnitAttack) -> void:
	attack_name.text = a.attack_name
	damage_label.text = str( roundi(a.get_actual_damage()) )
	accuracy_label.text = UnitInfoPanel.get_accuracy_text( a.accuracy )
	initiative_label.text = str(a.initiative)
	type_label.text = UnitInfoPanel.attack_type_to_str(a.type)
	attack_effects.fill_effects(a.applying_effects)

func _fill_data_attack_data(a: UnitAttackData) -> void:
	attack_name.text = a.attack_name
	var dmg := a.get_actual_damage()
	damage_label.text = "—" if is_nan(dmg) else str( roundi(dmg) )
	accuracy_label.text = UnitInfoPanel.get_accuracy_text(a.accuracy)
	initiative_label.text = str(a.initiative)
	type_label.text = UnitInfoPanel.attack_type_to_str(a.type)
	attack_effects.fill_effects(a.applying_effects)
