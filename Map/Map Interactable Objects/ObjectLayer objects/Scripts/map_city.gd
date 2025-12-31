class_name MapCity
extends ObjectLayerObject

## Units available for recruitment in this specific city.[br][br]
## [b]Note:[/b] Combined with faction-wide available units, with both lists
## filtered by [member available_units_whitelist] and [member available_units_blacklist].
## Units included here but excluded by filters will remain unavailable.
@export var available_units: Array[StringName]
## Filter criteria for units available in this city.[br]
## If non-empty, only units meeting at least one criterion will be available.[br][br]
## Each array entry is a criterion dictionary.
## A criterion is satisfied only when ALL its key-value pairs match
## corresponding entries in the unit's database record.
## Units missing any specified key do not satisfy the criterion.
## [i](make sure the spelling matches with database entries)[/i][br][br]
## Check the [UnitData] documentation for valid parameters reference.
@export var available_units_whitelist: Array[Dictionary]
## Filter criteria to exclude units from availability in this city.[br]
## Units meeting any criterion will be excluded from recruitment.[br][br]
## See [member available_units_whitelist] for reference.
@export var available_units_blacklist: Array[Dictionary]

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

func _request_player_interaction(faction: MapFaction) -> bool:
	if map.active_party: return false
	return faction == object_owner

func _player_interact(faction: MapFaction) -> void:
	map.game.ui_layers.switch_to_city(self)

#endregion

#func _initialize() -> void:
	#ownable = true

var units: Array[UnitData]:
	get:
		var res: Array[UnitData] = []
		for c in get_children():
			if c is UnitData:
				res.append(c)
		return res

var party_inside: MapParty

func _does_meet_criterion(unit: Dictionary, criterion: Dictionary) -> bool:
	for key: Variant in criterion:
		if key not in unit:
			# debug warning in case the key is spelled wrong
			print_debug("Unit '%s' does not have '%s' key in the database")
			return false
		var val: Variant = unit[key]
		if val == criterion[key]: continue
		return false
	return true

func _passes_whitelist(unit: Dictionary) -> bool:
	if not available_units_whitelist: return true
	for criterion in available_units_whitelist:
		if _does_meet_criterion(unit, criterion): return true
	return false

func _passes_blacklist(unit: Dictionary) -> bool:
	if not available_units_blacklist: return true
	for criterion in available_units_blacklist:
		if _does_meet_criterion(unit, criterion): return false
	return true

func get_avaliable_units() -> Array[StringName]:
	var res: Array[StringName] = []
	if object_owner:
		res = object_owner.hiring_units
		for u in available_units:
			if u not in res: res.append(u)
	else: res = available_units
	var checking_whitelist := not available_units_whitelist.is_empty()
	for unit_name: StringName in res.duplicate():
		var unit: Dictionary = GlobalDefs.database_path.database.get(unit_name, {})
		if not unit:
			res.erase(unit_name)
			continue
		if not (_passes_whitelist(unit) and _passes_blacklist(unit)):
			res.erase(unit_name)
	return res
