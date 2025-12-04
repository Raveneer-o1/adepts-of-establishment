extends ObjectLayerObject


#region Abstract Implementation

# Uncomment and implement the method below if the object occupies multiple tiles
#func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
#	# Return axial coordinates of all tiles this object occupies when placed at 'main'
#	# (must include the main tile itself)
#	# This assumes Godot's Stairs Right hex grid layout. To determine offsets,
#	# place your object at (0,0) and note coordinates of all occupied tiles.
#
#	# Example: An object forming a triangle that occupies the main hex (0,0),
#	# the hex directly above (0,-1), and the hex above-right (1,-1):
#	return [
#		main,
#		main + Vector2i(0, -1),
#		main + Vector2i(1, -1),
#	]

func interact(party: MapParty) -> void:
	# Implement interaction logic between the provided party and this object
	return

func request_interaction(party: MapParty) -> bool:
	# Return whether interaction with the provided party is possible
	# If null is provided, return the default value used for visual hints
	if not party: return false
	return false

func _can_party_pass(party: MapParty) -> bool:
	return false

func _can_travel_through(travel: TravelData) -> bool:
	return false

func passable(party: Variant) -> bool:
	# Determine if the provided party can pass through this object
	# Argument can be either MapParty object or TravelData object
	if party is MapParty: return _can_party_pass(party)
	if party is TravelData: return _can_travel_through(party)
	
	push_error("Invalid argument passed to '%s' object! Expected MapParty or TravelData, got %s!" % \
		[object_name, type_string(typeof(party))])
	return false

func request_player_interaction(faction: MapFaction) -> bool:
	# Return whether the player can interact with this object
	# Includes actions like selecting active party or opening capital window
	# NOTE: Only handles "left-click" interactions
	#       "right-click" for information and game settings are managed separately
	return false

func player_interact(faction: MapFaction) -> void:
	# Handle player interaction with this object
	# Includes actions like selecting active party or opening capital window
	# NOTE: Only handles "left-click" interactions
	#       "right-click" for information and game settings are managed separately
	return

#endregion
