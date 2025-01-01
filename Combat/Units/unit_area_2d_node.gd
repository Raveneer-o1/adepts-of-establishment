extends Area2D

#@onready var unit: Unit = get_parent()
@onready var highlight_node = $HighlightAnimation

func _on_mouse_entered() -> void:
	highlight_node.visible = true


func _on_mouse_exited() -> void:
	highlight_node.visible = false

const CLICK_TIMING = 0.3

var time_since_press := 0.0
var waiting_for_release := false

func start_waiting_for_release() -> void:
	time_since_press = 0.0
	waiting_for_release = true

func _process(delta: float) -> void:
	if waiting_for_release:
		time_since_press += delta
		waiting_for_release = time_since_press <= CLICK_TIMING

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_waiting_for_release()
			else:
				if not waiting_for_release:
					return
				waiting_for_release = false
				(get_parent() as Unit).click()
