class_name UI_DamageTypeTexture
extends TextureRect

@export var texturePhysical: Texture
@export var textureElemental: Texture
@export var textureMind: Texture
@export var textureLife: Texture
@export var textureNone: Texture

func set_val(type: GlobalDefs.AttackType) -> void:
	match type:
		GlobalDefs.AttackType.Physical: 
			texture = texturePhysical
			tooltip_text = "Physical"
		GlobalDefs.AttackType.Elemental: 
			texture = textureElemental
			tooltip_text = "Elemental"
		GlobalDefs.AttackType.Mind: 
			texture = textureMind
			tooltip_text = "Mind"
		GlobalDefs.AttackType.Life: 
			texture = textureLife
			tooltip_text = "Life"
		GlobalDefs.AttackType.None: 
			texture = textureNone
			tooltip_text = "None"
