class_name MapCapital
extends ObjectLayerObject

func get_interaction_tiles(
	main: Vector2i = tile_position,
	party: MapParty = null
) -> Array[Vector2i]:
	return [
		main + Vector2i(0, 1),
		main + Vector2i(-1, 1),
	]

func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	return [
		main,
		main + Vector2i(1, 0),
		main + Vector2i(-1, 0),
		main + Vector2i(-1, -1),
		main + Vector2i(0, -1),
		main + Vector2i(1, -1),
		main + Vector2i(2, -1),
		main + Vector2i(0, -2),
		main + Vector2i(1, -2),
		main + Vector2i(2, -2),
	]

#region Abstract Implementation

func can_interact(party: MapParty) -> bool:
	# Return whether interaction with the provided party is possible
	# If null is provided, return the default value used for visual hints
	if not party: return false
	return true

func accept_interaction(party: MapParty) -> void:
	# Implement interaction logic between the provided party and this object
	print("Hi")

func will_intercept(party: MapParty) -> bool:
	# This method returns true if it intercepts passing by parties
	# For example, enemies force battles on each other
	return false

func force_interaction_on(party: MapParty) -> void:
	# Redefine this method if your object needs to do something different when
	# intercepting other parties
	accept_interaction(party)

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
