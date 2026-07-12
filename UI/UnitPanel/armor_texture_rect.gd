class_name UI_UnitPanel_ArmorContainer
extends VBoxContainer

const SHIELD_WIDTH = 32.0
const MAX_SHIEDS = 10

@onready var armor_texture_rect: TextureRect = $Armor_TextureRect
@onready var label: Label = $Label

const ARMOR_TEXT = "%d armor"
const NO_ARMOR_TEXT = "This unit has no armor"

func set_value(val: int) -> void:
	#label.text = str(val)
	
	var fraction: float = float(val) / float(UnitParameters.ARMOR_SCALE)
	fraction *= MAX_SHIEDS
	if fraction <= 1.0:
		armor_texture_rect.hide()  # 0 min size does not hide the texture
		label.show()
		tooltip_text = NO_ARMOR_TEXT
		return
	tooltip_text = ARMOR_TEXT % val
	label.hide()
	armor_texture_rect.show()
	fraction = roundf(fraction) * SHIELD_WIDTH
	armor_texture_rect.custom_minimum_size.x = fraction
