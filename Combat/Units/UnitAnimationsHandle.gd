class_name UnitAnimationsHandle extends AnimatedSprite2D

@onready var parent_unit: Unit = get_parent() as Unit

@export var frames_to_emit: Array[int] = []

## After this frame all attacks are resolved and player can act
@export var last_frame: int = -1

var now_attacking: bool = false

var next_animation: StringName

func finish_death_animation() -> void:
	(get_parent() as Unit).visualize_death()


func play_death_animation() -> void:
	(get_child(0) as AnimationPlayer).play("unit_standart_death_animation")

func play_attack_animation() -> void:
	if animation != "default":
		next_animation = "attack"
		return
	play("attack")
	now_attacking = true

func _process(delta: float) -> void:
	pass
	#print(now_attacking)


func play_damage_animation(message: String = "") -> void:
	if message != "":
		if sprite_frames.has_animation(message):
			play(message)
			return
		if (get_child(0) as AnimationPlayer).has_animation(message):
			(get_child(0) as AnimationPlayer).play(message)
			return
	
	var anim_name := "damage"
	if sprite_frames.has_animation(anim_name):
		play(anim_name)
	else :
		if not (get_child(0) as AnimationPlayer).is_playing():
			(get_child(0) as AnimationPlayer).play("unit_standart_damage_animation")

func play_heal_animation() -> void:
	var anim_name := "heal"
	if sprite_frames.has_animation(anim_name):
		play(anim_name)
	else :
		(get_child(0) as AnimationPlayer).play("unit_standart_heal_animation")

func finish_attack() -> void:
	now_attacking = false
	parent_unit.finish_attacking()

func play_animation_by_name(animation_name: StringName) -> void:
	match animation_name:
		"attack":
			play_attack_animation()
			return
		"death":
			play_death_animation()
			return
		"damage":
			play_damage_animation()
			return
		"heal":
			play_heal_animation()
			return
	print_debug("Unable to map '%s' animation!" % animation_name)
	play("default")

func _on_animation_finished() -> void:
	play("default")
	if now_attacking:
		finish_attack()
	
	if next_animation != "":
		play_animation_by_name(next_animation)
		next_animation = ""
	

func _on_frame_changed() -> void:
	if not now_attacking:
		return
	if frames_to_emit.has(frame):
		EventBus.attack_reached.emit(parent_unit)
	if last_frame > 0 and frame >= last_frame:
		finish_attack()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if next_animation != "":
		play_animation_by_name(next_animation)
		next_animation = ""
