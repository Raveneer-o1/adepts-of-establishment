class_name MapParty
extends MapInteractableObject

@onready var animation_handle: MapPartyAnimationHandle = $AnimationHandle
@onready var parameters: PartyParameters = $PartyParameters
@onready var control: PartyControl = $Control

@export var faction: MapFaction

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for ch in get_children():
			if ch is UnitData:
				res.append(ch)
		return res

var is_moving: bool:
	get: return control.is_moving

#region Abstract Definitions

func interact(party: MapParty) -> void:
	if party.faction != faction:
		map.start_battle(party, self)

func request_interaction(party: MapParty) -> bool:
	if not party: return false
	if not faction or not party.faction: return false
	return party.faction != faction

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

func update_parameters() -> void:
	for u in units:
		if not u.is_dead: return
	die()

func die() -> void:
	map.free_map_object(self)
