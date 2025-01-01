class_name UnitAnimationsHandle extends AnimatedSprite2D

@onready var parent_unit: Unit = get_parent() as Unit

func play_attack_animation() -> void:
	play("attack")

func play_damage_animation() -> void:
	var anim_name = "damage"
	if sprite_frames.has_animation(anim_name):
		play(anim_name)
	else :
		(get_child(0) as AnimationPlayer).play("unit_standart_damage_animation")


func _on_animation_finished() -> void:
	play("default")
	parent_unit.finish_attacking()
