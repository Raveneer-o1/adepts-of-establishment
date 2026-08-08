extends Control

const DEFAULT_SIZE = Vector2(1600.0, 900.0)
const DEFAULT_SCALE = Vector2(1.0, 1.0)

func _on_resized() -> void:
	if not $Combat: return
	var _scale := minf(
		size.x / DEFAULT_SIZE.x,
		size.y / DEFAULT_SIZE.y,
	)
	$Combat.scale = _scale * DEFAULT_SCALE
