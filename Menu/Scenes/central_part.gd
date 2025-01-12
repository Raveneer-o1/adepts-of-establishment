extends VBoxContainer

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is UnitPanel

## If player drops a unit here, delete that unit
func _drop_data(at_position: Vector2, data: Variant) -> void:
	((data as UnitPanel).get_parent() as MenuUnitPlace). clear_child_info()
	(data as UnitPanel).queue_free()
