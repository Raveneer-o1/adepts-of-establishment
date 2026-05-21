class_name MapTileData
extends Sprite2D

#region References
var tile_owner: MapFaction = null:
	get: return tile_owner
	set(value):
		tile_owner = value
		if not value:
			hide()
			return
		show()
		self_modulate = value.main_color
var coordinates: Vector2i
var map: Map
var tile_data: TileData
#endregion

#region Parameters
## Determines if this tile can be claimed by a faction
var claimable: bool
## Defines the difficulty of claiming this tile. Has no effect when [member claimable]
## is [code]false[/code] or [member loyal_to] is [code]null[/code].
## Only influences calculations for the faction specified in [member loyal_to].[br][br]
## Calculates tile loyalty dynamically when accessed, not updated each turn.
## This trade-off reduces flexibility but avoids connecting
## [signal EventBus.map_turn_started] to every map tile.
var loyalty: float = 1.0:
	get:
		var days_owned := map.game.turn_manager.currnt_day - claimed_day
		if days_owned < 0: push_error("Negative days owned")
		if days_owned <= 0: return loyalty
		if loyal_to == tile_owner:
			return loyalty + days_owned * LOYALTY_INCREASE
		var accumulated := loyalty - days_owned * LOYALTY_INCREASE
		if accumulated >= 0.0: return accumulated
		loyalty = -accumulated
		loyal_to = tile_owner
		claimed_day = map.game.turn_manager.currnt_day
		return loyalty
	set(value): loyalty = value
var claimed_loyalty: float = 0.0
## Specifies which faction receives benefits from high [member loyalty] values.
var loyal_to: MapFaction = null
## If this value reaches zero, the tile is claimed. By default, ranges from
## [code]0.0[/code] to [code]1.0[/code]
var claim_status: float = 0.0
## Turn on which this tile was claimed
var claimed_day: int = -1
# enum instead of boolean to include more visibility options in the future
# e.g., open but not visible
var visible_to: Dictionary[MapFaction, VisibilityMode] = {}
#endregion

## Each turn loyalty of all claimed tiles is increased by this amount
const LOYALTY_INCREASE = 0.025
const TERRAIN_ATLAS_ID = 2

func set_visibility(
	faction: MapFaction,
	visibility: VisibilityMode = VisibilityMode.Visible
) -> void:
	visible_to[faction] = visibility
	map.update_visibility(self)

func is_under_fog_of_war(faction: MapFaction) -> bool:
	var mode: VisibilityMode = visible_to.get(faction, VisibilityMode.Hidden)
	match mode:
		VisibilityMode.Hidden: return true
		VisibilityMode.Visible: return false
	return true

func _hindered_claim(faction: MapFaction, power: float) -> bool:
	if is_zero_approx(loyalty):
		return not is_zero_approx(power)
	var claim_power := power / loyalty
	claim_status -= claim_power
	return claim_status <= 0.0

func _helped_claim(faction: MapFaction, power: float) -> bool:
	var claim_power := power * loyalty
	claim_status -= claim_power
	return claim_status <= 0.0

func _regular_claim(faction: MapFaction, power: float) -> bool:
	claim_status -= power
	return claim_status <= 0.0

func _claim(faction: MapFaction, power: float) -> bool:
	if not claimable: return false
	if tile_owner == faction: return false
	if loyal_to == tile_owner: return _hindered_claim(faction, power)
	if loyal_to == faction: return _helped_claim(faction, power)
	return _regular_claim(faction, power)

func _update_owner(faction: MapFaction) -> void:
	var previous_owner := tile_owner
	tile_owner = faction
	map.terrain_layer.set_cell(
		coordinates,
		TERRAIN_ATLAS_ID,
		faction.tile_atlas_coords.pick_random()
	)
	claim_status = 1.0
	claimed_loyalty = loyalty
	claimed_day = map.game.turn_manager.currnt_day
	EventBus.tile_claimed.emit(self, previous_owner)

## Tries to claim the tile. Returns if the claim was successful.
func try_claiming(faction: MapFaction, power: float) -> bool:
	var claimed := _claim(faction, power)
	if claimed: _update_owner(faction)
	return claimed

## Returns all neighbors of this tile
func get_neighbors() -> Array[MapTileData]:
	var neighbor_coords := map.get_neighbors(coordinates)
	var res: Array[MapTileData] = []
	for coords in neighbor_coords:
		var data:= map.get_tile_data(coords)
		if data: res.append(data)
	return res

func _find_map() -> Map:
	var parent := get_parent()
	while parent:
		if parent is Map: return parent
		parent = parent.get_parent()
	return null

func _ready() -> void:
	map = _find_map()
	assert(map)
	coordinates = map.get_tile_coords(global_position)
	tile_data = map.terrain_layer.get_cell_tile_data(coordinates)
	claimable = tile_data.get_custom_data("claimable")
	tile_owner = null

enum VisibilityMode{
	Hidden,
	Visible,
}
