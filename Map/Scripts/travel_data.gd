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


var safe_travel: bool
## @experimental: can be [code]null[/code]
var travelling_party: MapParty

var _cost_multiplier: int = 1

## [codeblock]
## func (tile_data: TileData) -> bool
## [/codeblock]
var custom_pass_check: Callable
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

func get_cost(tile_data: TileData) -> int:
	if custom_cost.is_valid(): return custom_cost.call(tile_data)
	return tile_data.get_custom_data("traverse_cost") * _cost_multiplier

func can_traverse(tile_data: TileData) -> bool:
	if custom_pass_check.is_valid(): return custom_pass_check.call(tile_data)
	return default_traversability(tile_data)
