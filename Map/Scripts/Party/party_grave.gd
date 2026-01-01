class_name MapPartyGrave
extends MapInteractableObject


# Uncomment and implement the method below if the object occupies multiple tiles
#func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
#	# Return axial coordinates of all tiles this object occupies when placed at 'main'
#	# (must include the main tile itself)
#	# This assumes Godot's Stairs Right hex grid layout. To determine offsets,
#	# place your object at (0,0) and note coordinates of all occupied tiles.
#
#	# Example: An object forming a triangle that occupies the main hex (0,0),
#	# the hex above-left (0,-1), and the hex above-right (1,-1):
#	return [
#		main,
#		main + Vector2i(0, -1),
#		main + Vector2i(1, -1),
#	]

# Uncomment and implement the method below if the object interacts with parties
# on tiles other than its current position
#func get_interaction_tiles(
#	party: MapParty = null,
#	main: Vector2i = tile_position,
#) -> Array[Vector2i]:
#	# Example: Enables interaction from neighboring tiles
#	return map.get_neighbors(main)

const PARTY_LINE = "%s (%d units)\n"

func get_description() -> String:
	var res := object_name
	for party in get_buried_parties():
		res += PARTY_LINE % [party.party_name, party.units.size()]
	return res

func right_click_processed() -> bool:
	EventBus.popup_requested.emit(self)
	return true

#region Abstract Implementation

func can_interact(party: MapParty) -> bool:
	return false

func accept_interaction(party: MapParty) -> int:
	return 0

func will_intercept(party: MapParty) -> bool:
	return false

func force_interaction_on(party: MapParty) -> int:
	return accept_interaction(party)

func _can_party_pass(party: MapParty) -> bool:
	return true

func _can_travel_through(travel: TravelData) -> bool:
	return true

func passable(party: Variant) -> bool:
	# Determine if the provided party can pass through this object
	# Argument can be either MapParty object or TravelData object
	if party is MapParty: return _can_party_pass(party)
	if party is TravelData: return _can_travel_through(party)
	
	push_error("Invalid argument passed to '%s' object! Expected MapParty or TravelData, got %s!" % \
		[object_name, type_string(typeof(party))])
	return false

func _request_player_interaction(faction: MapFaction) -> bool:
	# Return whether the player can interact with this object
	# Includes actions like selecting active party or opening capital window
	# NOTE: Only handles "left-click" interactions
	#       "right-click" for information and game settings are managed separately
	return false

func _player_interact(faction: MapFaction) -> void:
	# Handle player interaction with this object
	# Includes actions like selecting active party or opening capital window
	# NOTE: Only handles "left-click" interactions
	#       "right-click" for information and game settings are managed separately
	return

#endregion

func _initialize() -> void:
	# This method is called in _ready()
	# You can not override _ready() as it contains vital validation checks and 
	# reference initialization
	pass

func get_buried_parties() -> Array[MapParty]:
	var res: Array[MapParty] = []
	for child in get_children():
		if child is MapParty: res.append(child)
	return res

func bury_party(party: MapParty) -> void:
	if not party: return
	party.reparent(self, false)
	party.hide()
