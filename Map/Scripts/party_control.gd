class_name PartyControl
extends Node

@onready var this_party: MapParty = $".."

var cancel_movement: bool:
	get: return this_party.cancel_movement
	set(value): this_party.cancel_movement = value
var tile_position: Vector2i:
	get: return this_party.tile_position
	set(value): this_party.tile_position = value
var animation_handle: MapPartyAnimationHandle:
	get: return this_party.animation_handle
var map: Map:
	get: return this_party.map

## Number of tiles the unit can traverse per second. [br]
## [b]Note:[/b] Actual movement time is proportional to path length -
## the movement timer restarts after reaching each tile in the path.
const MAP_SPEED = 5.0

## Moves the party to the specified coordinates. [br]
## If [param animate] is [code]false[/code], the unit teleports instantly to the destination.[br]
## [color=red]Warning:[/color] This method performs no validation - it can move
## units to any tile, including non-existent or impassable locations.
func walk_to(
	destination: Vector2i,
	animate: bool = true,
) -> void:
	EventBus.party_move_started.emit(this_party, destination)
	if cancel_movement:
		cancel_movement = false
		_is_moving = false
		return
	this_party.face_tile(destination)
	tile_position = destination
	if animate:
		_smooth_movement = true
		animation_handle.play_walk()
		_start_moving_animation(destination)
		await _moving_finished
		_smooth_movement = false
	else: _jump_to(destination)
	_finish_moving_animation()
	# safeguard against misaligned position
	this_party.global_position = _moving_to

func _check_interception() -> bool:
	for o in map.get_interactions_on_tile(tile_position):
		if o == this_party: continue
		if o.will_intercept(this_party):
			o.force_interaction_on(this_party)
			return true
	return false

## Moves a party along a proveded coordinates [br]
## [color=red]Warning:[/color] This method performs no validation - it can move
## units through any tile, including non-existent or impassable locations.
func walk_along_path(
	path: Array[Vector2i],
	animate: bool = true,
) -> void:
	for destination in path:
		EventBus.party_move_started.emit(this_party, destination)
		if cancel_movement:
			cancel_movement = false
			_is_moving = false
			return
		this_party.face_tile(destination)
		animation_handle.play_walk()
		tile_position = destination
		if animate:
			_start_moving_animation(destination)
			await _moving_finished
		else: _jump_to(destination)
		if _check_interception():
			_finish_moving_animation()
			
			# safeguard against misaligned position
			this_party.global_position = _moving_to
			return
	
	_finish_moving_animation()
	
	# safeguard against misaligned position
	this_party.global_position = _moving_to

## Equivalent to setting [member cancel_movement] to [code]true[/code].[br]
## Stops the party's movement after completing the current step.[br]
## [br]
## 
## [b]Note:[/b] this only affects multi-tile movements initiated with
## [method walk_along_path].
## Single-step movements started with [method walk_to] are unaffected.[br]
## [i]Exception: During [signal EventBus.party_move_started] processing, movement can be
## canceled entirely since the signal fires before movement begins.[/i]
func abort_moving() -> void:
	cancel_movement = true

func _process(delta: float) -> void:
	if _is_moving: _process_movement(delta)

#region Private

func _process_movement(delta: float) -> void:
	_time_passed += delta
	if _smooth_movement:
		var weight := _time_passed / _time_to_reach
		
		# This provides non-linear movement which is preferable in this case
		# The result looks better than linear interpolation and
		# is faster than standard acceleration + velocity approaches
		this_party.global_position = \
			this_party.global_position.lerp(_moving_to, clampf(weight, 0.0, 1.0))
		
		if weight >= 1.0: _finish_moving()
	else:
		this_party.global_position += _moving_velocity * delta
		if _time_passed >= _time_to_reach: _finish_moving()

signal _moving_finished

var _smooth_movement: bool = false
var _is_moving: bool = false
var is_moving: bool:
	get: return _is_moving
var _moving_to: Vector2
var _moving_velocity: Vector2
var _time_to_reach: float = 1.0 / MAP_SPEED
var _time_passed: float = 0.0

func _finish_moving() -> void:
	_moving_finished.emit()

func _finish_moving_animation() -> void:
	_is_moving = false
	animation_handle.play_default()

func _start_moving_animation(p: Vector2i, time: float = 1.0 / MAP_SPEED) -> void:
	_moving_to = map.get_global_coords(p)
	_moving_velocity = (_moving_to - this_party.global_position) / time
	_is_moving = true
	_time_to_reach = time
	_time_passed = 0.0

func _jump_to(p: Vector2i) -> void:
	this_party.global_position = map.get_global_coords(p)

#endregion
