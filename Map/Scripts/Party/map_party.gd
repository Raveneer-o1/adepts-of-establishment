class_name MapParty
extends MapInteractableObject

@onready var animation_handle: MapPartyAnimationHandle = $AnimationHandle
@onready var parameters: PartyParameters = $PartyParameters
@onready var control: PartyControl = $Control
@onready var inventory: PartyInventory = $Inventory

@export var faction: MapFaction
@export var party_name: String
@export_file_path("*") var portrait_texture: String

## When set to [code]true[/code], the next movement attempt is canceled and
## this flag automatically resets to [code]false[/code].
var cancel_movement: bool = false
var loaded_portrait: Resource
var inside_city: MapCity = null

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for ch in get_children():
			if ch is UnitData:
				res.append(ch)
		return res

var is_moving: bool:
	get: return control.is_moving

func get_interaction_tiles(
	party: MapParty = null,
	main: Vector2i = tile_position,
) -> Array[Vector2i]:
	return map.get_neighbors(main)

func _validate_refs() -> void:
	if not faction:
		push_error("Unassigned faction")
		map.free_map_object(self)

#region Abstract Definitions

func _initialize() -> void:
	loaded_portrait = load(portrait_texture)
	_validate_refs()

func accept_interaction(party: MapParty) -> int:
	if party.faction.is_enemy(faction):
		map.start_battle(party, self)
	return party.parameters.max_movement_points

func force_interaction_on(party: MapParty) -> int:
	if faction.is_enemy(party.faction):
		map.start_battle(party, self)
	return party.parameters.max_movement_points

func will_intercept(party: MapParty) -> bool:
	return faction.is_enemy(party.faction)

func can_interact(party: MapParty) -> bool:
	if not party: return false
	if not faction or not party.faction: return false
	return party.faction.is_enemy(faction)

func passable(party: Variant) -> bool:
	return true

func request_player_interaction(player: MapFaction) -> bool:
	return player == faction

func player_interact(player: MapFaction) -> void:
	if player == faction:
		map.set_active_party(self)

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

func update_parameters() -> void:
	for u in units:
		if not u.is_dead: return
	die()

func die() -> void:
	map.free_map_object(self)

func is_dead() -> bool:
	# TODO: implement this
	return is_queued_for_deletion()

func exit_city(tile: Vector2i) -> void:
	if not inside_city: return
	if tile not in inside_city.get_interaction_tiles(self):
		push_error("Unable to exit city on this tile: " + str(tile))
		return
	inside_city.party_inside = null
	inside_city = null
	control.walk_to(tile)

func enter_city(city: MapCity) -> void:
	if not city: return
	if city.party_inside: return
	inside_city = city
	city.party_inside = self
	control.walk_to(city.tile_position)
