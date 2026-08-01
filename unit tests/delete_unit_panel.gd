class_name UnitTests_UnitDeletePanel
extends Panel

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Unit

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not data: return
	if data is not Unit: return
	var unit: Unit = data
	unit.deactivate()
	unit.queue_free()
