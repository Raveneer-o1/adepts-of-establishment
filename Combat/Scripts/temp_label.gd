extends Label

const LIFE_TIME = 1.5
const VISIBLE_TIME = 0.8
const SPEED = 20.0

var life := 0.0

func _process(delta: float) -> void:
	life += delta
	if life > LIFE_TIME:
		queue_free()
	modulate.a -= delta / VISIBLE_TIME
	position += Vector2(0, -SPEED * delta)
