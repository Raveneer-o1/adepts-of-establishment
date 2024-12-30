extends Area2D

#@onready var unit: Unit = get_parent()
@onready var highlight_node = $HighlightAnimation

func _on_mouse_entered() -> void:
	highlight_node.visible = true


func _on_mouse_exited() -> void:
	highlight_node.visible = false
