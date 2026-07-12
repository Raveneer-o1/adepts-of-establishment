class_name UI_UnitPanel_ArmorContainer
extends VBoxContainer

const SHIELD_WIDTH = 32.0
const MAX_SHIEDS = 10

@onready var armor_texture_rect: TextureRect = $Armor_TextureRect
@onready var label: Label = $Label


func set_value(val: int) -> void:
	var fraction: float = float(val) / float(UnitParameters.ARMOR_SCALE)
	fraction *= MAX_SHIEDS
	fraction = snappedf(fraction, SHIELD_WIDTH)
	label.text = str(val)
	if is_zero_approx(fraction):
		hide()  # 0 min size does not hide the texture
		return
	armor_texture_rect.custom_minimum_size.x = fraction
