extends Control

const DEFAULT_SIZE = Vector2(1600.0, 900.0)
const DEFAULT_SCALE = Vector2(3.5, 3.5)
#const DEFAULT_SIZE_LENGTH := sqrt(DEFAULT_SIZE.x * DEFAULT_SIZE.x + DEFAULT_SIZE.y * DEFAULT_SIZE.y)

@onready var layer_floor: TileMapLayer = $Floor
@onready var layer_light: TileMapLayer = $Light
@onready var layer_light_2: TileMapLayer = $Light2
@onready var layer_walls_and_decor: TileMapLayer = $"Walls and decor"

@onready var layers: Array[TileMapLayer] = [
	layer_floor,
	layer_light,
	layer_light_2,
	layer_walls_and_decor,
]

func _on_resized() -> void:
	var _scale := minf(
		size.x / DEFAULT_SIZE.x,
		size.y / DEFAULT_SIZE.y,
	)
	for layer in layers:
		layer.scale = _scale * DEFAULT_SCALE
