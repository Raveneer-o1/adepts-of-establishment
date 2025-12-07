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
## [br][br]
## [MapInteractableObject] automatically locates the [Map] node by traversing
## the scene tree upward. If no Map node is found (reaching the root),
## an error is generated and the object is freed.

var map: Map
var object_name: String = ""

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
	return [main]

## Processes interaction initiated by the specified [param party]. [br][br]
## Override this method in derived classes. It generally performs no validation
## beyond basic input filtering. Use [method can_interact] to verify interaction
## validity beforehand, or call this directly to force interaction regardless.
@abstract func accept_interaction(party: MapParty) -> void
## Processes interaction with the specified [param party] initiated by this object.
## [br][br]
## Override this method in derived classes. It generally performs no validation
## beyond basic input filtering. Use [method can_interact] to verify interaction
## validity beforehand, or call this directly to force interaction regardless.
@abstract func force_interaction_on(party: MapParty) -> void
## Determines whether interaction with this object is currently available.
## Returns [code]true[/code] if the tile should highlight as interactable
## when the player hovers over this object with a party selected. [br][br]
## [b]Important:[/b] This method does not validate the party's position.
## Verify valid interaction locations using [method get_interaction_tiles]
## or use [method validate_and_interact] for automatic validation. [br][br]
## [b]Note:[/b] This method checks interaction availability for the [b]party[/b],
## not the player. For player interaction checks, use [method request_player_interaction].
@abstract func can_interact(party: MapParty) -> bool
## Determines whether this object should intercept parties passing by.
## For example, enemy parties intercept parties to start a combat.
@abstract func will_intercept(party: MapParty) -> bool
@abstract func passable(party: Variant) -> bool
#@abstract func click_response(active_faction: MapFaction) -> void

@abstract func request_player_interaction(faction: MapFaction) -> bool
@abstract func player_interact(faction: MapFaction) -> void

func _initialize() -> void:
	pass

## Attempts interaction with the specified [param party] if conditions permit.
## Returns [code]true[/code] if interaction occurred successfully.
## If [param forced] is [code]true[/code], uses [method force_interaction_on];
## otherwise uses [method accept_interaction].
func validate_and_interact(party: MapParty, forced: bool = false) -> bool:
	if not can_interact(party): return false
	if party.tile_position not in get_interaction_tiles(party): return false
	if forced: force_interaction_on(party)
	else: accept_interaction(party)
	return true

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

func _register_object() -> void:
	tile_position = map.objects_layer.local_to_map(
		map.objects_layer.to_local(global_position)
	)
	_initialize()

func _ready() -> void:
	var next_parent := get_parent()
	while next_parent and not map:
		if next_parent is Map: map = next_parent
		else: next_parent = next_parent.get_parent()
	if not map:
		push_error("Unable to find map for object '%s'" % object_name)
		queue_free()
		return
	_register_object.call_deferred()
