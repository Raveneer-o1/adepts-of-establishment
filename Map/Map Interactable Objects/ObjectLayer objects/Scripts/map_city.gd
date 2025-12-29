class_name MapCity
extends ObjectLayerObject

## @deprecated: use [member MapInteractableObject.object_owner] instead
## Returns [member MapInteractableObject.object_owner]
var city_owner: MapFaction:
	get: return object_owner
	set(value): object_owner = value

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
	if map.active_party: return false
	return faction == object_owner

func player_interact(faction: MapFaction) -> void:
	_request_switching()

#endregion

func _request_switching() -> void:
	# TODO: redesign this solution
	# individual objects should not call UI functions directly
	map.game.ui_layers.switch_to_city(self)

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for c in get_children():
			if c is UnitData:
				res.append(c)
		return res

var party_inside: MapParty

#func _initialize() -> void:
	#ownable = true
