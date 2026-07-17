class_name UI_UnitPanel_ArmorContainer
extends VBoxContainer

const SHIELD_WIDTH = 32.0
const MAX_SHIEDS = 10

@onready var weakness_texture_rect: TextureRect = $Weakness_TextureRect
@onready var armor_texture_rect: TextureRect = $Armor_TextureRect
@onready var label: Label = $Label

const ARMOR_TEXT = "%d armor"
const VULNERABILITY_TEXT = "%d vulnerability"
const NO_ARMOR_TEXT = "This unit has no armor"

func set_value(val: int) -> void:
	#label.text = str(val)
	
	var fraction: float = float(val) / float(UnitParameters.ARMOR_SCALE)
	fraction *= MAX_SHIEDS
	armor_texture_rect.hide()
	weakness_texture_rect.hide()
	if absf(fraction) <= 1.0:
		label.show()
		tooltip_text = NO_ARMOR_TEXT
		return
	tooltip_text = (ARMOR_TEXT if fraction > 0.0 else VULNERABILITY_TEXT) % absi(val)
	label.hide()
	var texture: TextureRect = armor_texture_rect if fraction > 0.0 else weakness_texture_rect
	texture.show()
	fraction = roundf(absf(fraction)) * SHIELD_WIDTH
	texture.custom_minimum_size.x = fraction
