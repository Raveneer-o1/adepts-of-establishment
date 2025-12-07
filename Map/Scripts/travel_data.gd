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

# TODO: traversable tiles mask
var _default_cost_multiplier: int = 1

## [codeblock]
## func (tile_data: TileData) -> bool
## [/codeblock]
var custom_pass_check: Callable
## [codeblock]
## func (tile_data: TileData) -> int
## [/codeblock]
var custom_cost_multiplier: Callable

func _init(party: MapParty) -> void:
	if not party: return
	_default_cost_multiplier = party.parameters.get_movement_multiplier()
	

func get_cost_multiplier(tile_data: TileData) -> int:
	if custom_cost_multiplier.is_valid(): return custom_cost_multiplier.call(tile_data)
	return _default_cost_multiplier

func _default_traversability(tile_data: TileData) -> bool:
	var tile_type: StringName = tile_data.get_custom_data("tile_type")
	match tile_type:
		&"ground": return true
		&"water": return true
		&"sand": return true
		&"forest": return true
		#&"mountain": return false
	
	# white-list approach doesn't let unexpected tile types to be passable
	return false

func can_traverse(tile_data: TileData) -> bool:
	if custom_pass_check.is_valid(): return custom_pass_check.call(tile_data)
	return _default_traversability(tile_data)
