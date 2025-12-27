class_name MapTileData
extends RefCounted

#region References
var tile_owner: MapFaction = null
var coordinates: Vector2i
var map: Map
var tile_data: TileData
#endregion

#region Parameters
## Determines if this tile can be claimed by a faction
var claimable: bool
## Defines the difficulty of claiming this tile. Has no effect when [member claimable]
## is [code]false[/code] or [member loyal_to] is [code]null[/code].
## Only influences calculations for the faction specified in [member loyal_to].
var loyalty: float = 1.0
## Specifies which faction receives benefits from high [member loyalty] values.
var loyal_to: MapFaction = null
## If this value reaches zero, the tile is claimed
var claim_status: float = 0.0
#endregion

const TERRAIN_ATLAS_ID = 2

func _hindered_claim(faction: MapFaction, power: float) -> bool:
	if is_zero_approx(loyalty):
		return true
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
	EventBus.tile_claimed.emit(self, previous_owner)

## Tries to claim the tile. Returns if the claim was successful.
func try_claiming(faction: MapFaction, power: float) -> bool:
	var claimed := _claim(faction, power)
	if claimed: _update_owner(faction)
	return claimed

func get_neighbors() -> Array[MapTileData]:
	var neighbor_coords := map.get_neighbors(coordinates)
	var res: Array[MapTileData] = []
	for coords in neighbor_coords:
		var data:= map.get_tile_data(coords)
		if data: res.append(data)
	return res

func _init(coords: Vector2i, _map: Map) -> void:
	coordinates = coords
	map = _map
	tile_data = map.terrain_layer.get_cell_tile_data(coords)
	claimable = tile_data.get_custom_data("claimable")
