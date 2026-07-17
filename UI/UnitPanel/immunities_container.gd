class_name UI_UnitPanel_ImmunitiesContainer
extends VBoxContainer

const DAMAGETYPE_TEXTURE_RECT = preload("uid://bstufbu4uucgy")
const IMMUNITIES_TEXT := "Immunities: "
const NO_IMMUNITIES_TOOLTIP := "This unit has no immunities"

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var label: Label = $Label

func set_value(a: Array[GlobalDefs.AttackType]) -> void:
	for c in h_box_container.get_children(): c.queue_free()
	label.text = IMMUNITIES_TEXT
	
	if not a:
		label.text += "—"
		tooltip_text = NO_IMMUNITIES_TOOLTIP
	else: tooltip_text = ""
	for t in a:
		var texture: UI_DamageTypeTexture = DAMAGETYPE_TEXTURE_RECT.instantiate()
		h_box_container.add_child(texture)
		texture.set_val(t)
