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
var game: GameMap:
	get: return this_party.map.game

## Number of tiles the party can traverse per second.
var map_speed: float = 5.0:
	get:
		return map_speed if not this_party else \
			(
				GameSettings.player_party_speed if \
				this_party.object_owner == game.screen_player else \
				GameSettings.AI_party_speed
			)

func _handle_step(destination: Vector2i) -> bool:
	if this_party.parameters.movement_points <= 0: return false
	var tile_data := map.get_tile_data(destination)
	if not tile_data:
		push_error("Trying to move to an empty tile")
		return false
	this_party.parameters.subtract_mp(
		this_party.parameters.get_movement_cost(tile_data)
	)
	game.update_active_party(this_party)
	return true

func _check_interception(target_object: MapInteractableObject = null) -> bool:
	var o := map.get_first_interception(tile_position, this_party)
	if not o: return false
	# don't interact with target object
	if o == target_object: return true
	
	_intercept(o)
	return true

func _intercept(object: MapInteractableObject) -> void:
	@warning_ignore("redundant_await")
	var cost := await object.force_interaction_on(this_party)
	this_party.parameters.subtract_mp(cost)


## Moves the party to the specified coordinates. [br]
## If [param animate] is [code]false[/code], the unit teleports instantly to the destination.[br]
## [color=red]Warning:[/color] This method performs no validation - it can move
## units to any tile, including non-existent or impassable locations.
func walk_to(
	destination: Vector2i,
	animate: bool = true,
) -> void:
	cancel_movement = false
	await _walk_to(destination, animate)
	_finish_moving_animation()
	
	# safeguard against misaligned position
	this_party.global_position = _moving_to

func _walk_to(
	destination: Vector2i,
	animate: bool,
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

## Moves a party along a proveded coordinates [br][br]
## if [param target_object] ia specified, ignores interception from that object
## (expected to be handled by caller) [br][br]
## Returns if the party reached the destination without interruptions.
func walk_along_path(
	path: Array[Vector2i],
	animate: bool = true,
	target_object: MapInteractableObject = null
) -> bool:
	if not path: return true
	cancel_movement = false
	if this_party.inside_city: this_party.exit_city(path[0])
	var interrupted := await _walk_along_path(path, animate, target_object)
	_finish_moving_animation()
	
	# safeguard against misaligned position
	this_party.global_position = _moving_to
	return not interrupted

func _walk_along_path(
	path: Array[Vector2i],
	animate: bool = true,
	target_object: MapInteractableObject = null
) -> bool:
	for destination in path:
		EventBus.party_move_started.emit(this_party, destination)
		if cancel_movement:
			cancel_movement = false
			return true
		if not _handle_step(destination): 
			return true
		this_party.face_tile(destination)
		animation_handle.play_walk()
		tile_position = destination
		if animate:
			_start_moving_animation(destination)
			await _moving_finished
			# might want to add checks after the control returns to this function
			# theoretically, during the step process, party could've
			# been changed or even freed
			
			# Raveneer-o1 24.12.2025
			# won't happen with current implementation but worth considering for
			# future features
		else: _jump_to(destination)
		if _check_interception(target_object):
			return true
	
	return false

## Equivalent to setting [member cancel_movement] to [code]true[/code].[br]
## Stops the party's movement after completing the current step.[br]
## [i]Exception: During [signal EventBus.party_move_started] processing, movement can be
## canceled entirely since the signal is emitted before movement begins.[/i] [br]
## [b]Note:[/b] this only affects multi-tile movements initiated with
## [method walk_along_path].
## Single-step movements started with [method walk_to] are unaffected.[br]
func abort_moving() -> void:
	cancel_movement = true
	if _is_moving: await _moving_finished
	#else: cancel_movement = false


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
var _time_to_reach: float = 1.0 / map_speed
var _time_passed: float = 0.0

func _finish_moving() -> void:
	cancel_movement = false
	EventBus.party_moved.emit(this_party)
	#print_debug("party_moved emitted %s" % str(tile_position))
	_moving_finished.emit()
	this_party.object_modified.emit()

func _finish_moving_animation() -> void:
	_is_moving = false
	animation_handle.play_default()
	this_party.object_modified.emit()

func _start_moving_animation(p: Vector2i, time: float = 1.0 / map_speed) -> void:
	_moving_to = map.get_global_coords(p)
	_moving_velocity = (_moving_to - this_party.global_position) / time
	_is_moving = true
	_time_to_reach = time
	_time_passed = 0.0

func _jump_to(p: Vector2i) -> void:
	this_party.global_position = map.get_global_coords(p)

#endregion
