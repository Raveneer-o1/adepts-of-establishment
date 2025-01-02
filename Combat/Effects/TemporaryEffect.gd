extends AnimatedSprite2D
class_name TemporaryEffect

func _on_animation_finished() -> void:
	queue_free()
