class_name MapParty
extends MapInteractableObject

@onready var animation_handle: MapPartyAnimationHandle = $AnimationHandle
@onready var parameters: PartyParameters = $PartyParameters

@export var faction: MapFaction

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for ch in get_children():
			if ch is UnitData:
				res.append(ch)
		return res

#region Abstract Definitions

func interact(party: MapParty = null) -> void:
	if party.faction != faction:
		map.start_battle(party, self)

func request_interaction(party: MapParty = null) -> bool:
	if not party: return false
	if not faction or not party.faction: return false
	return party.faction != faction

func passable(party: MapParty = null) -> bool:
	return true
#@abstract func click_response(active_faction: MapFaction) -> void

func request_player_interaction(player: MapFaction) -> bool:
	return false

func player_interact(player: MapFaction) -> void:
	pass

#endregion

func get_battle_ready_units() -> Array[UnitData]:
	var res: Array[UnitData] = []
	for ch in get_children():
		if ch is UnitData:
			if ch.party_position >= 0:
				res.append(ch)
	res.sort_custom(
		func(e1: UnitData, e2: UnitData) -> bool:
			return e1.party_position < e2.party_position
	)
	var i := -1
	for d: UnitData in res.duplicate():
		if d.party_position == i:
			push_error("Duplacate position %d" % i)
			res.erase(d)
		i = d.party_position
	return res

## Number of tiles the unit can traverse per second. [br]
## [b]Note:[/b] Actual movement time is proportional to path length -
## the movement timer restarts after reaching each tile in the path.
const MAP_SPEED = 5.0

## When set to [code]true[/code], the next movement attempt is canceled and
## this flag automatically resets to [code]false[/code].
var cancel_movement: bool = false

## Flips the sprite to face the specified [param target] tile. [br]
## This method assumes axial coordinates (Godot's [b]Stairs[/b] or
## [b]Diamond[/b] layouts) and will produce incorrect results with offset
## coordinates (Godot's [b]Stacked[/b] layouts).
func face_tile(target: Vector2i) -> void:
	var d := target - tile_position
	if d == Vector2i.ZERO: return
	if d.x != 0:
		animation_handle.flip_h = d.x < 0
		return
	animation_handle.flip_h = d.y < 0

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
		_is_moving = false
		return
	face_tile(destination)
	tile_position = destination
	if animate:
		_smooth_movement = true
		animation_handle.play_walk()
		_start_moving_animation(destination)
		await _moving_finished
		_smooth_movement = false
		animation_handle.play_default()
	else: _jump_to(destination)
	_finish_moving_animation()
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
			_is_moving = false
			return
		face_tile(destination)
		animation_handle.play_walk()
		tile_position = destination
		if animate:
			_start_moving_animation(destination)
			await _moving_finished
		else: _jump_to(destination)
		animation_handle.play_default()
	_finish_moving_animation()
	
	# safeguard against misaligned position
	global_position = _moving_to

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

func update_parameters() -> void:
	for u in units:
		if not u.is_dead: return
	die()

func die() -> void:
	queue_free()

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
		global_position = global_position.lerp(_moving_to, clampf(weight, 0.0, 1.0))
		
		if weight >= 1.0: _finish_moving()
	else:
		global_position += _moving_velocity * delta
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
	_moving_velocity = (_moving_to - global_position) / time
	_is_moving = true
	_time_to_reach = time
	_time_passed = 0.0

func _jump_to(p: Vector2i) -> void:
	global_position = map.get_global_coords(p)

#endregion
