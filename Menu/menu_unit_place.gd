extends Container
class_name  MenuUnitPlace

const UNIT_PANEL = preload("res://Menu/Scenes/unit_panel.tscn")
var panel: UnitPanel

func add_new_unit(unit_name: String, dir: String) -> void:
	if panel != null:
		panel.queue_free()
		clear_child_info()
	panel = UNIT_PANEL.instantiate()
	add_child(panel)
	panel.label_text = unit_name
	panel.directory = dir

func clear_child_info() -> void:
	if is_instance_valid(panel):
		remove_child(panel)
	panel = null

func switch_unit_place(unit: UnitPanel) -> void:
	var other_place := (unit.get_parent() as MenuUnitPlace)
	var this_unit := panel
	
	other_place.clear_child_info()
	clear_child_info()
	
	panel = unit
	add_child(unit)
	
	if this_unit != null:
		other_place.panel = this_unit
		other_place.add_child(this_unit)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is TreeItemUnit:
		add_new_unit(data.unit_name, data.path)
	elif data is UnitPanel:
		switch_unit_place(data)
	
