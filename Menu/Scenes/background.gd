extends Control

@onready var sky: TextureRect = $sky
@onready var clouds: TextureRect = $clouds
@onready var near_clouds: TextureRect = $"near clouds"
@onready var far_mountains: TextureRect = $"far mountains"
@onready var mountains: TextureRect = $mountains
@onready var trees: TextureRect = $trees

@onready var default_scales: Dictionary[TextureRect, Vector2] = {
	sky: Vector2(6.0, 6.0),
	clouds: Vector2(4.0, 4.0),
	near_clouds: Vector2(4.0, 4.0),
	far_mountains: Vector2(4.0, 4.0),
	mountains: Vector2(4.0, 4.0),
	trees: Vector2(4.0, 4.0),
}

const DEFAULT_SIZE = Vector2(1600.0, 900.0)

func _on_resized() -> void:
	var _scale := minf(
		size.x / DEFAULT_SIZE.x,
		size.y / DEFAULT_SIZE.y,
	)
	for rect in default_scales:
		rect.scale = _scale * default_scales[rect]
