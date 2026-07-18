class_name UnitAnimationsHandle extends AnimatedSprite2D

@onready var parent_unit: Unit = get_parent() as Unit

## List of frames at which the [signal EventBus.attack_reached] is emitted.
## Set this to the frames where the attack connects visualy.
@export var frames_to_emit: Array[int] = []

## All attacks are finalized after this frame number, allowing player input
## before animations complete. [br]
## Value of -1 indicates attacks will finalize only after their animations finish completely.
@export var last_frame: int = -1

@export var attack_sound_frame: int = 1

var now_attacking: bool = false

var next_animation: StringName

func finish_death_animation() -> void:
	(get_parent() as Unit).visualize_death()
	$AnimationPlayer.play(&"RESET")
	play(&"default")
	pause()


func play_death_animation() -> void:
	(get_child(0) as AnimationPlayer).play(&"unit_standard_death_animation")

func play_attack_animation(index := 0) -> void:
	var target_animation := &"attack2" \
		if index != 0 and sprite_frames.has_animation(&"attack2") \
		else &"attack"
	if animation != &"default":
		next_animation = target_animation
		return
	if sprite_frames.has_animation(target_animation):
		play(target_animation)
	else:
		(get_child(0) as AnimationPlayer).play(&"unit_standard_attack_animation")
	if attack_sound_frame == 0:
		parent_unit.sound_player.play_attack_sound()
	now_attacking = true


func play_damage_animation(message: String = "") -> void:
	if message != "":
		if sprite_frames.has_animation(message):
			play(message)
			return
		if (get_child(0) as AnimationPlayer).has_animation(message):
			(get_child(0) as AnimationPlayer).play(message)
			return
	
	var anim_name := &"damage"
	if sprite_frames.has_animation(anim_name):
		play(anim_name)
	else :
		if not (get_child(0) as AnimationPlayer).is_playing():
			(get_child(0) as AnimationPlayer).play(&"unit_standard_damage_animation")

func play_heal_animation() -> void:
	var anim_name := &"heal"
	if sprite_frames.has_animation(anim_name):
		play(anim_name)
	else:
		(get_child(0) as AnimationPlayer).play(&"unit_standard_heal_animation")

func finish_attack() -> void:
	now_attacking = false
	parent_unit.finish_attacking()

func play_animation_by_name(animation_name: StringName) -> void:
	match animation_name:
		&"attack":
			play_attack_animation()
			return
		&"attack2":
			play_attack_animation(1)
			return
		&"death":
			play_death_animation()
			return
		&"damage":
			play_damage_animation()
			return
		&"heal":
			play_heal_animation()
			return
	push_error("Unable to map '%s' animation!" % animation_name)
	play(&"default")

func _on_animation_finished() -> void:
	play(&"default")
	if now_attacking:
		finish_attack()
	
	if next_animation != &"":
		play_animation_by_name(next_animation)
		next_animation = &""


func _on_frame_changed() -> void:
	if not now_attacking:
		return
	if frames_to_emit.has(frame):
		EventBus.attack_reached.emit(parent_unit)
	if last_frame > 0 and frame >= last_frame:
		finish_attack()
	if frame == attack_sound_frame and attack_sound_frame > 0:
		parent_unit.sound_player.play_attack_sound()
	if frame == 0:
		_on_animation_finished()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if next_animation != &"":
		play_animation_by_name(next_animation)
		next_animation = &""
