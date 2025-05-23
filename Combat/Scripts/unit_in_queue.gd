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
	
	if disable_player:
		$AnimationPlayer.active = false
		(get_parent() as Control).custom_minimum_size = Vector2.ZERO
		(get_parent() as Control).size.x = 0

const LARGE_SCALE = Vector2(1.2, 1.2)
const NORMAL_SCALE = Vector2(1.0, 1.0)
const CUSTOM_MINIMUM = Vector2(65, 0)

var queue: MiniatureQueueManager

var disable_player: bool = true

var click_enabled: bool = false

func pause_animation() -> void:
	$AnimationPlayer.pause()

func animate_enter() -> void:
	$AnimationPlayer.active = true
	$AnimationPlayer.play(&"queue_enter_animation")
	disable_player = false
	click_enabled = true

func animate_exit() -> void:
	click_enabled = false
	$AnimationPlayer.play(&"queue_exit_animation")

func animate_shift_to_hide(pos: float) -> void:
	const KEYFRAME_TIME = 1.1
	
	var anim: Animation = $AnimationPlayer.get_animation(&"queue_shift_to_hide_animation")
	var track_id: int = anim.find_track(".:position", Animation.TYPE_VALUE)
	var key_id: int = anim.track_find_key(track_id, KEYFRAME_TIME)
	anim.track_set_enabled(track_id, true)
	anim.track_set_key_value(track_id, key_id, Vector2(pos, 0.0))
	
	disable_player = true
	click_enabled = false
	$AnimationPlayer.play(&"queue_shift_to_hide_animation")

func animate_shift(pos: float) -> void:
	const KEYFRAME_TIME = 1.1
	#const BOUNCE = 10.5
	
	#print(position)
	var anim: Animation = $AnimationPlayer.get_animation(&"queue_shift_animation")
	var track_id: int = anim.find_track(".:position", Animation.TYPE_VALUE)
	var key_id: int = anim.track_find_key(track_id, KEYFRAME_TIME)
	anim.track_set_enabled(track_id, true)
	anim.track_set_key_value(track_id, key_id, Vector2(pos, 0.0))
	
	$AnimationPlayer.play(&"queue_shift_animation")


func _on_shift_animation_finished() -> void:
	#print(position)
	queue.end_shifting_miniatures_animation.emit()
	var anim: Animation = $AnimationPlayer.get_animation(&"queue_shift_animation")
	var track_id: int = anim.find_track(".:position", Animation.TYPE_VALUE)
	anim.track_set_enabled(track_id, false)
	
	anim = $AnimationPlayer.get_animation(&"queue_shift_to_hide_animation")
	track_id = anim.find_track(".:position", Animation.TYPE_VALUE)
	anim.track_set_enabled(track_id, false)
	
	position = Vector2.ZERO

func _on_mouse_entered() -> void:
	if not click_enabled:
		return
	unit.spot.area_2d._on_mouse_entered()
	scale = LARGE_SCALE

func _on_mouse_exited() -> void:
	if not click_enabled:
		return
	unit.spot.area_2d._on_mouse_exited()
	scale = NORMAL_SCALE

func _on_gui_input(event: InputEvent) -> void:
	if not click_enabled:
		return
	unit.spot.area_2d._on_input_event(null, event, 0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"queue_exit_animation":
		return
	queue.add_new_miniature()
	get_parent().queue_free()
