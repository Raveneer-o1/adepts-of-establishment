class_name UI_UnitPanel_AttackPanel_Effects_EffectPanel
extends HBoxContainer

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

const REGION_SIZE = 8

func set_effect(eff: AppliedEffect) -> void:
	tooltip_text = eff.get_description()
	label.text = eff.effect_name
	@warning_ignore("integer_division")
	(texture_rect.texture as AtlasTexture).region.position = Vector2(
		eff.icon_index % 5 * REGION_SIZE,
		int(eff.icon_index / 5) * REGION_SIZE,
	)
