extends Node2D

@onready var terrain_layer : TileMapLayer = %TerrainLayer
@onready var objects_layer : TileMapLayer = %ObjectsLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data := terrain_layer.get_cell_tile_data(Vector2i(0, 0))
	data.terrain


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
