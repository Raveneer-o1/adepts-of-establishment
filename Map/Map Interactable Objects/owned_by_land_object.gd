@abstract
class_name OwnedByLandObject
extends ObjectLayerObject

func _check_claimed_tile(tile: MapTileData, prev: MapFaction) -> void:
	if tile.coordinates != tile_position: return
	object_owner = tile.tile_owner

func _register_object() -> void:
	# usually this is handled via editor
	ownable = true  # safeguard
	
	super._register_object()
	EventBus.tile_claimed.connect(_check_claimed_tile)
	var tile_data := map.get_tile_data(tile_position)
	if not tile_data: return
	object_owner = tile_data.tile_owner
