class_name UnitAnimationsHandle extends AnimatedSprite2D

@onready var parent_unit: Unit = get_parent() as Unit

@export var frames_to_emit: Array[int] = []

## After this frame all attacks are resolved and player can act
@export var last_frame: int = 0

var now_attacking: bool = false

func play_attack_animation() -> void:
	play("attack")
	now_attacking = true

func play_damage_animation() -> void:
	var anim_name = "damage"
	if sprite_frames.has_animation(anim_name):
		play(anim_name)
	else :
		(get_child(0) as AnimationPlayer).play("unit_standart_damage_animation")

func finish_attack() -> void:
	parent_unit.finish_attacking()
	now_attacking = false

func _on_animation_finished() -> void:
	play("default")
	if now_attacking:
		finish_attack()

func _on_frame_changed() -> void:
	if not now_attacking:
		return
	if frames_to_emit.has(frame):
		EventBus.attack_reached.emit(parent_unit)
	if last_frame > 0 and frame == last_frame:
		finish_attack()
