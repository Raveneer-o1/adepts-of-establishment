class_name LandClaimer
extends Node

## Total claim power of this object
@export var claim_power: float = 10.0
## Maximum claim power this object can exert on any particular tile
@export var max_claim_power: float = 1.5

@onready var this_object: MapInteractableObject = get_parent()

## List of all tiles for claiming.
var frontier: Array[MapTileData] = []

## List of all tiles under the influence of this object
var influence: Array[MapTileData] = []

var land_owner: MapFaction:
	get: return this_object.object_owner

## Calculates the entire area of influence and the frontier.
## This method can be slow for large maps, avoid calling it too often.
func set_influence_and_frontier() -> void:
	var open_set := this_object.get_occupied_tiles()
	# using hashtable because it's faster than arrays to check if element already exists
	# and eliminates the need to filter out duplicates
	var ht := {}
	var frontier_ht := {}
	while open_set:
		var current_coords: Vector2i = open_set.pop_front()
		var current_data := this_object.map.get_tile_data(current_coords)
		if not current_data: continue
		if current_data.tile_owner != land_owner:
			frontier_ht[current_data] = null
			continue
		if ht.has(current_data): continue
		for n in current_data.get_neighbors():
			if ht.has(n): continue
			if n.claimable:
				if n.tile_owner == land_owner:
					open_set.append(n.coordinates)
				else:
					frontier_ht[n] = null
		ht[current_data] = null
	influence.assign(ht.keys())
	frontier.assign(frontier_ht.keys())
	_setting = false

## Applies claim power (see [member claim_power]) to all tiles in the
## [member frontier].
func apply_claim() -> void:
	var power := clampf(claim_power / frontier.size(), 0.0, max_claim_power)
	for tile in frontier:
		tile.try_claiming(land_owner, power)

var _tiles_to_check_frontier: Array[MapTileData] = []
var _tiles_to_check_influence: Array[MapTileData] = []

var _setting := false

func _check_claimed_tile(tile: MapTileData, previous_owner: MapFaction) -> void:
	if _setting: return
	if tile.tile_owner == previous_owner: return
	if tile in influence or tile in frontier:
		set_influence_and_frontier.call_deferred()
		_setting = true

func _check_turn_start(f: MapFaction) -> void:
	if not f: return
	# empty tile_atlas_coords means inactive land claiming
	if not f.tile_atlas_coords: return
	if f == land_owner: apply_claim()

func _ready() -> void:
	EventBus.tile_claimed.connect(_check_claimed_tile)
	EventBus.map_turn_started.connect(_check_turn_start)
	this_object.object_changed.connect.call_deferred(set_influence_and_frontier)
	set_influence_and_frontier.call_deferred()
