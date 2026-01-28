@abstract
class_name MapInteractableObject
extends Node2D

## Abstract base class for all interactive objects on the map.
##
## Instances of this class should not be freed during runtime. If you need to 
## remove a [MapInteractableObject], consider these alternatives: [br]
## - Preserve the object and store its data elsewhere. For example: defeated parties
## can generate graves that store the party data as child nodes 
## [i](for future resurrection or statistic gathering)[/i]. [br]
## - Utilize the object layer system. [MapObjectsLayer] provides management wrappers
## (see [method MapObjectsLayer.set_tile]) that handle object lifecycle automatically.
## This approach suits disposable objects like treasure bags that disappear when collected.
## [br][br]
## If neither alternative works and object removal is necessary, do not use
## [method queue_free] directly since map nodes maintain references to all
## [MapInteractableObject] instances. Instead, use [method Map.free_map_object].

## When set, automatically determines [member object_owner] during game initialization.
## Takes precedence over [member faction_index].
## Only affects initial setup - do not use during gameplay.
@export var owner_capital: MapCapital

## When set (non negative), automatically determines [member object_owner]
## during game initialization. Ignored if [member owner_capital] is specified.
## Only affects initial setup - do not use during gameplay.
@export var faction_index: int = -1

## Reference to the [Map] node containing this object. [br]
## [MapInteractableObject] automatically locates the this node by traversing
## the scene tree upward. If no Map node is found (reaching the root),
## an error is generated and the object is freed.
var map: Map
@export var object_name: String = ""

## If [member ownable] is [code]false[/code], always returns [code]null[/code].
## When ownership is enabled, tracks the controlling faction.
## Can be [code]null[/code] even for ownable objects, indicating unclaimed status.
## [br][br]
## When editing the map, you can assign [member owner_capital] or 
## [member faction_index] to set the owner of the object.
var object_owner: MapFaction = null:
	get: return object_owner if ownable else null
	set(value):
		if object_owner == value: return
		object_owner = value
		object_changed.emit()

## Determines whether this object can be owned by a faction.
## When [code]false[/code], [member object_owner] always returns [code]null[/code]
## regardless of assignment attempts.
@export var ownable: bool = false

## Determines whether the object is considered by the [Map] node during
## interaction calculations. Does not prevent direct calls to
## [method accept_interaction] or [method force_interaction_on],
## only controls whether the map automatically triggers these methods.
var is_active: bool = true

## Determines interaction priority when multiple objects occupy the same tile.
## Higher values receive priority; negative values are permitted.
@export var interaction_priority: int = 0
## Determines interaction priority when party can interact with multiple objects.
## Higher values receive priority; negative values are permitted.
@export var party_interaction_priority: int = 0

@onready var units_container: UnitsContainer = _find_units_container()

func _find_units_container() -> UnitsContainer:
	for c in get_children():
		if c is UnitsContainer: return c
	return null

## Processes right-click interaction with this object.
## Returns [code]true[/code] if the right-click was consumed.
## Intended to prevent multiple windows or popups from a single input.
func right_click_processed() -> bool:
	return false

func _move_mapping(destination: Vector2i) -> void:
	for t in get_occupied_tiles():
		if map.tile_to_object.has(t):
			map.tile_to_object[t].erase(self)
	for t in get_occupied_tiles(destination):
		if map.tile_to_object.has(t):
			map.tile_to_object[t].append(self)
		else:
			map.tile_to_object[t] = [self]
	
	for t in get_interaction_tiles():
		if map.tile_to_interaction.has(t):
			map.tile_to_interaction[t].erase(self)
	for t in get_interaction_tiles(null, destination):
		if map.tile_to_interaction.has(t):
			map.tile_to_interaction[t].append(self)
		else:
			map.tile_to_interaction[t] = [self]

var tile_position: Vector2i:
	get: return tile_position
	set(value):
		if tile_position == value: return
		if not map:
			push_error("Map reference is empty! (%s)" % object_name)
			tile_position = value
			return
		_move_mapping(value)
		tile_position = value

## Returns an array of tiles this object would occupy if placed at the specified
## [param main] tile. Uses the object's current tile position by default. [br][br]
## [color=yellow]
## This method assumes the [b]Stairs Right[/b] hex layout and will procude incorrect
## results for other grid types, including [b]Stairs Left[/b] and [b]Diamond[/b].
## [/color]
func get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	# Potential redesign: implement layout-specific methods such as
	# _get_occupied_tiles_axial(), 
	# _get_occupied_tiles_axial_swapped(), 
	# _get_occupied_tiles_offset(),
	# and have this public method delegate to the appropriate one.
	return _get_occupied_tiles(main)

func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	return [main]

## @experimental: Currently returns tiles for all interaction types.
## With future introduction of distinct interaction categories,
## the implementation of this method may change. [br][br]
## Returns tiles where [param party] must be positioned to interact with this object
## when the object is at [param main] tile.[br][br]
## Uses current position by default. If [param party] is not specified, returns
## all positions available for any interaction.
func get_interaction_tiles(
	party: MapParty = null,
	main: Vector2i = tile_position,
) -> Array[Vector2i]:
	return get_occupied_tiles(main)

## Processes interaction initiated by the specified [param party]. [br][br]
## This method performs no validation beyond basic input filtering.
## Use [method can_interact] or [method validate_and_interact] to verify
## interaction validity beforehand, or call this directly
## to force interaction regardless. [br][br]
## [b]Returns:[/b] Interaction cost in movement points.
## Does not deduct movement points from the party - caller must handle this.
@abstract func accept_interaction(party: MapParty) -> int
## Processes interaction with the specified [param party] initiated by this object.
## [br][br]
## This method performs no validation beyond basic input filtering.
## Use [method can_interact] or [method validate_and_interact] to verify
## interaction validity beforehand, or call this directly
## to force interaction regardless. [br][br]
## [b]Returns:[/b] Interaction cost in movement points.
## Does not deduct movement points from the party - caller must handle this.
@abstract func force_interaction_on(party: MapParty) -> int
## Determines whether interaction with this object is currently available.
## Returns [code]true[/code] if the tile should highlight as interactable
## when the player hovers over this object with a party selected. [br][br]
## [b]Important:[/b] This method does not validate the party's position.
## Verify valid interaction locations using [method get_interaction_tiles]
## or use [method validate_and_interact] for automatic validation. [br][br]
## [b]Note:[/b] This method checks interaction availability for the [b]party[/b],
## not the player. For player interaction checks, use [method _request_player_interaction].
@abstract func can_interact(party: MapParty) -> bool
## Determines whether this object should intercept parties passing by.
## For example, enemy parties intercept parties to start a combat.
@abstract func will_intercept(party: MapParty) -> bool
## Returns if the object is passable to the specified [param party].
## Argument can be either [MapParty] or [TravelData].
@abstract func passable(party: Variant) -> bool

## Returns if the object responds to player clicks.
## This wrapper verifies
## [codeblock]
## faction == game.screen_player
## [/codeblock]
## before delegating to object-specific implementation.
func request_player_interaction(faction: MapFaction) -> bool:
	if map.game.screen_player == faction:
		return _request_player_interaction(faction)
	return false

## Processes player's click on this object.
## This wrapper verifies
## [codeblock]
## faction == game.screen_player
## [/codeblock]
## before delegating to object-specific implementation.[br][br]
## [color=red][b]Important:[/b][/color] Derived classes may invoke UI functions
## within this method - handle subsequent operations carefully.
func player_interact(faction: MapFaction) -> void:
	if map.game.screen_player == faction:
		_player_interact(faction)

@abstract func _request_player_interaction(faction: MapFaction) -> bool
@abstract func _player_interact(faction: MapFaction) -> void

## Emitted when the object undergoes significant transformation
## (e.g., ownership change).
## Expected to trigger full reinitialization if required.
signal object_changed
## Emitted for minor object modifications that don't warrant full reinitialization.
## May not require any response beyond internal updates.
signal object_modified

func _initialize() -> void:
	pass

## Attempts interaction with the specified [param party] if conditions permit.
## This method does not allow interactions with deactiveted parties. 
## If you need to force the interaction, use [method accept_interaction]
## or [method force_interaction_on] directly. [br][br]
## Returns the interaction cost if successful, or [code]-1[/code] otherwise. [br][br]
## Similar to [method accept_interaction] and [method force_interaction_on],
## this method does not deduct movement points - the caller must handle this. [br][br]
## If [param forced] is [code]true[/code], uses [method force_interaction_on];
## otherwise uses [method accept_interaction].
func validate_and_interact(party: MapParty, forced: bool = false) -> int:
	if not is_active: return -1
	if not can_interact(party): return -1
	if party.tile_position not in get_interaction_tiles(party): return -1
	if forced: return force_interaction_on(party)
	return accept_interaction(party)

## Returns if the provided [param unit] can be transfered to this object.
func can_accept_unit(unit: UnitData) -> bool:
	if not units_container: return false
	if unit is HeroData:
		if unit.get_parent() == units_container: return true
	if unit.unit_owner != object_owner: return false
	return _can_accept_unit(unit)

func _can_accept_unit(unit: UnitData) -> bool:
	return true

var _object_registered := false

func get_description() -> String:
	return object_name

func register_object() -> void:
	if _object_registered: return
	tile_position = map.get_tile_coords(global_position)
	
	if owner_capital:
		owner_capital.register_object()
		object_owner = owner_capital.object_owner
	elif faction_index >= 0:
		object_owner = map.game.get_faction(faction_index)
	
	_initialize()
	_object_registered = true

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map for object '%s'" % object_name)
		queue_free()
		return
	register_object.call_deferred()
