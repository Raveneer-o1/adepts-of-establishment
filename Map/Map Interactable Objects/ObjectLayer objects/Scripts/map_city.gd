class_name MapCity
extends ObjectLayerObject

## @experimental: currently not implemented
var city_owner: MapFaction = null

func get_interaction_tiles(
	party: MapParty = null,
	main: Vector2i = tile_position,
) -> Array[Vector2i]:
	return [
		main + Vector2i(0, 1),
		main + Vector2i(-1, 1),
	]

func _get_occupied_tiles(main: Vector2i = tile_position) -> Array[Vector2i]:
	return [
		main,
		main + Vector2i(0, -1),
		main + Vector2i(1, -1),
		main + Vector2i(0, -2),
		main + Vector2i(1, -2),
		main + Vector2i(2, -2),
	]

func right_click_processed() -> bool:
	EventBus.popup_requested.emit(self)
	return true

#region Abstract Implementation

func can_interact(party: MapParty) -> bool:
	if not party: return false
	return true

func accept_interaction(party: MapParty) -> int:
	if city_owner.is_enemy(party.faction):
		if party_inside:
			map.start_battle(party, party_inside)
			return party.parameters.max_movement_points
		map.start_siege(party, self)
		return party.parameters.max_movement_points
	
	if party_inside: return 0
	party.enter_city(self)
	return 0

func will_intercept(party: MapParty) -> bool:
	# This method returns true if it intercepts passing by parties
	# For example, enemies force battles on each other
	return false

func force_interaction_on(party: MapParty) -> int:
	return accept_interaction(party)

func _can_party_pass(party: MapParty) -> bool:
	return false

func _can_travel_through(travel: TravelData) -> bool:
	return false

func passable(party: Variant) -> bool:
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

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for c in get_children():
			if c is UnitData:
				res.append(c)
		return res

var party_inside: MapParty

func _initialize() -> void:
	# TODO: replace with faction index
	city_owner = map.game.test_faction2
