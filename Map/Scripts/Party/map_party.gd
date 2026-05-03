class_name MapParty
extends MapInteractableObject


@onready var animation_handle: MapPartyAnimationHandle = $AnimationHandle
@onready var parameters: PartyParameters = $PartyParameters
@onready var control: PartyControl = $Control
@onready var inventory: PartyInventory = $Inventory

## @experimental: will be replaced with a formatted [member object_name] + leader name
@export var party_name: String
@export_file_path("*") var portrait_texture: String

## @deprecated: use [member MapInteractableObject.object_owner] instead
## Returns [member MapInteractableObject.object_owner]
var faction: MapFaction:
	get: return object_owner
	set(value): object_owner = value

## When set to [code]true[/code], the next movement attempt is canceled and
## this flag automatically resets to [code]false[/code].
var cancel_movement: bool = false
var loaded_portrait: Resource
var inside_city: MapCity = null

@export
var hero: HeroData = null

var is_moving: bool:
	get: return control.is_moving

var _behind_walls_effect: BehindWallsPartyEffect

## @experimental: Currently allows only one item per slot type. Future versions may support multiple items of the same type (e.g., two ring slots: first finger, second finger).
var equipped_items: Dictionary[EquippableMapItem.EquipmentSlot, EquippableMapItem]
var equipped_items_list: Array[MapItem]

func get_interaction_tiles(
	party: MapParty = null,
	main: Vector2i = tile_position,
) -> Array[Vector2i]:
	return map.get_neighbors(main)

func _validate_refs() -> void:
	if not faction:
		push_error("Unassigned faction")
		map.free_map_object(self)
	elif not units_container:
		push_error("Unassigned units_container")
		map.free_map_object(self)

func right_click_processed() -> bool:
	EventBus.popup_requested.emit(self)
	return true

var units: Array[UnitData]:
	get: return units_container.units

#region Abstract Definitions

func _initialize() -> void:
	#ownable = true
	loaded_portrait = load(portrait_texture)
	_validate_refs()
	if is_queued_for_deletion(): return
	object_name = "Party (%s)" % party_name
	for c in get_children():
		if c is UnitData: c.reparent(units_container)
	init_party_parameters()

func accept_interaction(party: MapParty) -> int:
	if party.faction.is_enemy(faction):
		map.start_battle(party, self)
	return party.parameters.max_movement_points

func force_interaction_on(party: MapParty) -> int:
	if faction.is_enemy(party.faction):
		map.start_battle(party, self)
	return party.parameters.max_movement_points

func will_intercept(party: MapParty) -> bool:
	if inside_city: return false
	return faction.is_enemy(party.faction)

func can_interact(party: MapParty) -> bool:
	if not party: return false
	if not faction or not party.faction: return false
	return party.faction.is_enemy(faction)

func passable(party: Variant) -> bool:
	if is_dead: return true
	if not is_active: return true
	return false

func _request_player_interaction(player: MapFaction) -> bool:
	return player and player == faction and player.api.ui_filter

func _player_interact(player: MapFaction) -> void:
	if not player: return
	if player != faction: return
	if not player.api.ui_filter: return
	map.set_active_party(self)

#endregion

## @experimental: this will be redesigned
func init_party_parameters() -> void:
	$FactionBanner.set_color(faction)

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
			push_error("Duplicate position %d" % i)
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

## Updates the parameters of all units in the party
func update_parameters() -> void:
	var _dead := true
	for u in units:
		if u.party_position >= 0 and not u.is_dead: _dead = false
		if u.levelup_available: await level_up_unit(u)
	if _dead: die()

const GRAVE_PREFAB = preload("res://Map/Scenes/party_grave.tscn")

## Deactivates the party and transfers it to a [MapPartyGrave] node.
## If a grave already exists at the party's position, moves the party there.
## Otherwise, creates a new grave instance.
func die() -> void:
	is_dead = true
	is_active = false
	for object: MapInteractableObject in map.tile_to_object.get(tile_position, []):
		if object is MapPartyGrave:
			object.bury_party(self)
			return
	var grave := map.object_manager.add_object(GRAVE_PREFAB, tile_position)
	if grave: grave.bury_party(self)
	else:
		push_error("Unable to instantiate a grave! Party will be deleted")
		map.free_map_object(self)

var is_dead: bool

## Exits the city. This method does not validate the target position.
func exit_city(tile: Vector2i) -> void:
	if not inside_city: return
	if tile not in inside_city.get_interaction_tiles(self):
		push_error("Unable to exit city on this tile: " + str(tile))
		return
	inside_city.party_inside = null
	inside_city = null
	control.walk_to(tile)
	if _behind_walls_effect: _behind_walls_effect.remove_effect()

func enter_city(city: MapCity) -> void:
	if not city: return
	if city.party_inside: return
	inside_city = city
	city.party_inside = self
	control.walk_to(city.tile_position)
	_behind_walls_effect = \
		parameters.apply_effect(
			"res://Map/PartyEffects/Scenes/behind_walls.tscn"
		)

## Moves specified [param item] to this party's inventory.
## [br][br]
## [b]Note:[/b] This method does not perform any validation:
## it can steal items from any location in the scene tree
func pick_up(items: Array[MapItem]) -> void:
	for item in items:
		if not item: continue
		if item.get_parent():
			item.reparent(inventory)
		else:
			inventory.add_child(item)
	if object_owner and object_owner.api.ui_filter:
		EventBus.window_requested.emit(items)

func level_up_unit(unit: UnitData) -> void:
	if not unit: return
	if not object_owner: unit.level_up()
	else: await object_owner.level_up_unit(unit)


func _can_accept_unit(unit: UnitData) -> bool:
	if units_container.get_occupied_space() >= parameters.get_capacity():
		return false
	return true
