class_name MapParty
extends Node2D

@onready var map: Map = get_parent() if get_parent() is Map else null
@onready var animation_handle: MapPartyAnimationHandle = $AnimationHandle

## Number of tiles the unit can traverse per second. [br]
## [b]Note:[/b] Actual movement time is proportional to path length -
## the movement timer restarts after reaching each tile in the path.
const MAP_SPEED = 5.0

var tile_position: Vector2i
var cancel_movement: bool = false

## Moves the party to the specified coordinates. [br]
## If [param animate] is [code]false[/code], the unit teleports instantly to the destination.[br]
## [color=red]Warning:[/color] This method performs no validation - it can move
## units to any tile, including non-existent or impassable locations.
func walk_to(
	destination: Vector2i,
	animate: bool = true,
) -> void:
	EventBus.party_move_started.emit(self, destination)
	if cancel_movement:
		cancel_movement = false
		return
	tile_position = destination
	if animate:
		_smooth_movement = true
		animation_handle.play_walk()
		_start_moving_animation(destination)
		await _moving_finished
		_smooth_movement = false
		animation_handle.play_default()
	else: _jump_to(destination)
	# safeguard against misaligned position
	global_position = _moving_to

## Moves a party along a proveded coordinates [br]
## [color=red]Warning:[/color] This method performs no validation - it can move
## units through any tile, including non-existent or impassable locations.
func walk_along_path(
	path: Array[Vector2i],
	speed_multiplier: float = 1.0,
	animate: bool = true,
) -> void:
	for destination in path:
		EventBus.party_move_started.emit(self, destination)
		if cancel_movement:
			cancel_movement = false
			return
		animation_handle.play_walk()
		tile_position = destination
		if animate:
			_start_moving_animation(destination)
			await _moving_finished
		else: _jump_to(destination)
		animation_handle.play_default()
	# safeguard against misaligned position
	global_position = _moving_to

func _process(delta: float) -> void:
	if _is_moving: _process_movement(delta)

func _process_movement(delta: float) -> void:
	_time_passed += delta
	if _smooth_movement:
		var weight := _time_passed / _time_to_reach
		
		# This provides non-linear movement which is preferable in this case
		# The result looks better than linear interpolation and
		# is faster than standard acceleration + velocity approaches
		global_position = global_position.lerp(_moving_to, clampf(weight, 0.0, 1.0))
		
		if weight >= 1.0: _finish_moving_animation()
	else:
		global_position += _moving_velocity * delta
		if _time_passed >= _time_to_reach: _finish_moving_animation()

signal _moving_finished

var _smooth_movement: bool = false
var _is_moving: bool = false
var _moving_to: Vector2
var _moving_velocity: Vector2
var _time_to_reach: float = 1.0 / MAP_SPEED
var _time_passed: float = 0.0

func _finish_moving_animation() -> void:
	_is_moving = false
	animation_handle.play_default()
	_moving_finished.emit()

func _start_moving_animation(p: Vector2i, time: float = 1.0 / MAP_SPEED) -> void:
	_moving_to = map.get_global_coords(p)
	_moving_velocity = (_moving_to - global_position) / time
	_is_moving = true
	_time_to_reach = time
	_time_passed = 0.0

func _jump_to(p: Vector2i) -> void:
	global_position = map.get_global_coords(p)
