class_name MapCamera
extends Camera2D

## @deprecated: installed StrategyCamera addon instead

@export var zoom_speed := 0.1
@export var movement_speed := 100.0
@export var min_zoom := 0.5
@export var max_zoom := 5.0

func zoom_in() -> void:
	if zoom.x >= max_zoom or zoom.y >= max_zoom: return
	zoom += Vector2.ONE * zoom_speed

func zoom_out() -> void:
	if zoom.x <= min_zoom or zoom.y <= min_zoom: return
	zoom -= Vector2.ONE * zoom_speed

var _drifting: bool = false
var _drifting_direction: Vector2:
	get:
		var res := Vector2.ZERO
		for v in _movement_buffer:
			res += Vector2(v)
		return res.normalized()
var _movement_buffer: Array[Vector2i] = []

func start_drift(direction: Vector2i) -> void:
	_drifting = true
	if direction == Vector2i.ZERO: return
	if direction in _movement_buffer: return
	var i := _movement_buffer.find(-direction)
	if i >= 0:
		_movement_buffer.remove_at(i)
		return
	_movement_buffer.append(direction)

func finish_drift() -> void:
	_drifting = false
	_movement_buffer.clear()

func _process(delta: float) -> void:
	if _drifting:
		position += _drifting_direction * movement_speed * delta
