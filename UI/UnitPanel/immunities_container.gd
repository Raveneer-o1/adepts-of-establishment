class_name UI_UnitPanel_ImmunitiesContainer
extends VBoxContainer

const DAMAGETYPE_TEXTURE_RECT = preload("uid://bstufbu4uucgy")
@onready var h_box_container: HBoxContainer = $HBoxContainer

func set_value(a: Array[GlobalDefs.AttackType]) -> void:
	for c in h_box_container.get_children(): c.queue_free()
	for t in a:
		var texture: UI_DamageTypeTexture = DAMAGETYPE_TEXTURE_RECT.instantiate()
		h_box_container.add_child(texture)
		texture.set_val(t)
