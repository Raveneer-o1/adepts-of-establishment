extends CanvasLayer


#func _on_control_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#(get_parent() as MapUI).switch_to(&"Main")
