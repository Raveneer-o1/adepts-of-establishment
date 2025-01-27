extends PanelContainer
class_name UnitInQueue

#@onready var player: AnimationPlayer = $AnimationPlayer

var combat_system: CombatSystem

var unit: Unit

var text: String

@onready var label: Label = $Label

func set_text() -> void:
	label.text = unit.unit_name

func _ready() -> void:
	get_parent().custom_minimum_size = CUSTOM_MINIMUM
	if unit != null:
		set_text()
	else :
		print_debug("Unit is not assigned")
		get_parent().queue_free()

const LARGE_SCALE = Vector2(1.2, 1.2)
const NORMAL_SCALE = Vector2(1.0, 1.0)
const CUSTOM_MINIMUM = Vector2(65, 0)

var queue: MiniatureQueueManager

func pause_animation() -> void:
	$AnimationPlayer.pause()

func animate_enter() -> void:
	$AnimationPlayer.active = true
	$AnimationPlayer.play(&"queue_enter_animation")

func animate_exit() -> void:
	$AnimationPlayer.play(&"queue_exit_animation")

func _on_mouse_entered() -> void:
	unit.spot.area_2d._on_mouse_entered()
	scale = LARGE_SCALE

func _on_mouse_exited() -> void:
	unit.spot.area_2d._on_mouse_exited()
	scale = NORMAL_SCALE

func _on_gui_input(event: InputEvent) -> void:
	unit.spot.area_2d._on_input_event(null, event, 0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"queue_exit_animation":
		return
	queue.add_new_miniature()
	get_parent().queue_free()
