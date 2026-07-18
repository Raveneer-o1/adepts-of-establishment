class_name UI_UnitPanel_AttackPanel
extends PanelContainer

@onready var damage_label: Label = $MarginContainer/VBoxContainer/DMG_ACC/DamageContainer/Label
@onready var accuracy_label: Label = $MarginContainer/VBoxContainer/DMG_ACC/AccuracyContainer/Label
@onready var initiative_label: Label = $MarginContainer/VBoxContainer/InitiativeContainer/Label
#@onready var type_label: Label = $MarginContainer/VBoxContainer/DMG_ACC/TypeContainer/Label
@onready var type_texture: UI_DamageTypeTexture = $MarginContainer/VBoxContainer/DMG_ACC/TypeContainer/TextureRect
@onready var attack_effects: UI_UnitPanel_AttackPanel_Effects = $MarginContainer/VBoxContainer/Attack_Effects_GridContainer
@onready var attack_name: Label = $MarginContainer/VBoxContainer/AttackName
@onready var effects_label: Label = $MarginContainer/VBoxContainer/EffectsLabel
@onready var description_label: RichTextLabel = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var accuracy_container: HBoxContainer = $MarginContainer/VBoxContainer/DMG_ACC/AccuracyContainer

const NO_EFFECTS_LINE = "—"
const EFFECTS_LINE = "Effects on hit:"
const NO_EFFECTS_TOOLTIP = "This attack applies no effects"
const UNEVADABLE_TOOLTIP_TEXT = "Accuracy\n(can't be evaded)"
const ACCURACY_TOOLTIP_TEXT = "Accuracy"

const UNEVADABLE_MODULATE = Color("52c4bd")
const BLANK_MODULATE = Color.WHITE

func fill_data(a: Variant) -> void:
	if a is UnitAttack: _fill_data_attack(a)
	elif a is UnitAttackData: _fill_data_attack_data(a)
	else: push_error("Unexpected type")

func _fill_data_attack(a: UnitAttack) -> void:
	attack_name.text = a.attack_name
	damage_label.text = _get_damage_text(a)
	accuracy_label.text = UnitInfoPanel.get_accuracy_text( a.accuracy )
	initiative_label.text = str(a.initiative)
	type_texture.set_val(a.type)
	attack_effects.fill_effects(a.applying_effects)
	if a.applying_effects:
		effects_label.text = EFFECTS_LINE
		effects_label.tooltip_text = ""
	else:
		effects_label.text = NO_EFFECTS_LINE
		effects_label.tooltip_text = NO_EFFECTS_TOOLTIP
	description_label.text = a.description
	if not a.evadable:
		accuracy_container.modulate = UNEVADABLE_MODULATE
		accuracy_container.tooltip_text = UNEVADABLE_TOOLTIP_TEXT
	else:
		accuracy_container.modulate = BLANK_MODULATE
		accuracy_container.tooltip_text = ACCURACY_TOOLTIP_TEXT

func _fill_data_attack_data(a: UnitAttackData) -> void:
	attack_name.text = a.attack_name
	damage_label.text = _get_damage_text_data(a)
	accuracy_label.text = UnitInfoPanel.get_accuracy_text(a.accuracy)
	initiative_label.text = str(a.initiative)
	type_texture.set_val(a.type)
	attack_effects.fill_effects(a.applying_effects)
	if a.applying_effects:
		effects_label.text = EFFECTS_LINE
		effects_label.tooltip_text = ""
	else:
		effects_label.text = NO_EFFECTS_LINE
		effects_label.tooltip_text = NO_EFFECTS_TOOLTIP
	description_label.text = a.description
	if not a.evadable:
		accuracy_container.modulate = UNEVADABLE_MODULATE
		accuracy_container.tooltip_text = UNEVADABLE_TOOLTIP_TEXT
	else:
		accuracy_container.modulate = BLANK_MODULATE
		accuracy_container.tooltip_text = ACCURACY_TOOLTIP_TEXT

func _get_damage_text(a: UnitAttack) -> String:
	var res := str( roundi(a.get_actual_damage()) )
	if (a.targets_needed > 1):
		res += "x%d" % a.targets_needed
	return res

func _get_damage_text_data(a: UnitAttackData) -> String:
	var dmg := a.get_actual_damage()
	if is_nan(dmg): return "—"
	var res := str( roundi(a.get_actual_damage()) )
	if (a.targets_needed > 1):
		res += " (x%d)" % a.targets_needed
	return res
