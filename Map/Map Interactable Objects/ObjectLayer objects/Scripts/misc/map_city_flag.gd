extends Node2D

@export var sprite: Node2D

var city: MapCity
var _last_owner: MapFaction

func _set_flag() -> void:
	sprite.modulate = _last_owner.main_color if _last_owner else Color.WHITE

func _check_flag() -> void:
	if _last_owner == city.object_owner: return
	_last_owner = city.object_owner
	_set_flag()

func _ready() -> void:
	var p := get_parent()
	if p is not MapCity:
		push_error("Flag is not attached to the city")
		queue_free()
		return
	if not sprite:
		push_error("Sprite not set")
		queue_free()
		return
	city = p
	city.object_changed.connect(_check_flag)
