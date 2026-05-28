class_name TravelData
extends RefCounted

## Contains travel parameters that affect pathfinding behavior
##
## Possible [code]tile_type[/code] values: [br]
## [code]&"ground"[/code][br]
## [code]&"water"[/code][br]
## [code]&"sand"[/code][br]
## [code]&"forest"[/code][br]
## [code]&"mountain"[/code][br]

## Returns if the provided [param tile_data] is traversable by default
static func default_traversability(tile_data: TileData) -> bool:
	var tile_type: StringName = tile_data.get_custom_data("tile_type")
	match tile_type:
		&"ground": return true
		&"water": return true
		&"sand": return true
		&"forest": return true
		#&"mountain": return false
	
	# white-list approach doesn't let unexpected tile types to be passable
	return false

enum Visibility_ID{
	always_hidden = -1,
	always_visible = 0,
	match_traversability = 1,
	visible_to_some = 2,
}

## Returns if the provided [param tile_data] can be seen through by default
static func default_transparency(tile_data: TileData) -> bool:
	var visibility_id: Visibility_ID = tile_data.get_custom_data("visibility_id")
	match visibility_id:
		Visibility_ID.match_traversability: return default_traversability(tile_data)
		Visibility_ID.always_hidden: return false
		Visibility_ID.visible_to_some: return false
	
	# black-list approach makes unexpected types visible
	return true

## Determines whether the party avoids forced interactions.
## Initialized to [member PartyParameters.safe_travel] if
## [member PartyParameters.safe_travel_override]
## is [code]true[/code], otherwise uses [member GameSettings.safe_travel].
## Directly influences pathfinding behavior when modified.
var safe_travel: bool
## @experimental: can be [code]null[/code]
var travelling_party: MapParty

var _cost_multiplier: int = 1

## [codeblock]
## func (tile_data: TileData) -> bool
## [/codeblock]
var custom_pass_check: Callable
## [codeblock]
## func (tile_data: TileData) -> bool
## [/codeblock]
var custom_sight_check: Callable
## [codeblock]
## func (tile_data: TileData) -> int
## [/codeblock]
var custom_cost: Callable

func _init(party: MapParty) -> void:
	if not party:
		push_error("Party is not provided")
		return
	var parameters := party.parameters
	_cost_multiplier = parameters.get_movement_multiplier()
	custom_cost = parameters.get_movement_cost
	safe_travel = parameters.safe_travel if \
		parameters.safe_travel_override else \
		GameSettings.safe_travel
	travelling_party = party
	custom_pass_check = parameters.check_pass
	# TODO: custom_sight_check = parameters.check_sight

## Returns the cost of traversing the provided [param tile]
func get_cost(tile: TileData) -> int:
	if custom_cost.is_valid(): return custom_cost.call(tile)
	return tile.get_custom_data("traverse_cost") * _cost_multiplier

## Returns if the provided [param tile] can be traversed
func can_traverse(tile_data: TileData) -> bool:
	if custom_pass_check.is_valid(): return custom_pass_check.call(tile_data)
	return default_traversability(tile_data)

## Returns whether the given [param tile] is both visible itself
## and does not block line of sight to tiles beyond it.
func can_see_through(tile_data: TileData) -> bool:
	if custom_sight_check.is_valid(): return custom_sight_check.call(tile_data)
	return default_transparency(tile_data)
	
