extends AnimatedSprite2D
class_name TemporaryEffect

@export var sound_delay: int = 0;

func _on_animation_finished() -> void:
	if frame_changed.is_connected(_on_frame_changed):
		frame_changed.disconnect(_on_frame_changed)
	if animation_finished.is_connected(_on_animation_finished):
		animation_finished.disconnect(_on_animation_finished)
	queue_free()

func play_all() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.play()

func _ready() -> void:
	if sound_delay <= 0:
		play_all()

func _on_frame_changed() -> void:
	if sound_delay <= 0: return
	sound_delay -= 1
	if sound_delay <= 0:
		play_all()
