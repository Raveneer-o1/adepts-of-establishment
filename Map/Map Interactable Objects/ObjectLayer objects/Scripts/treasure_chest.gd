extends ObjectLayerObject


#region Abstract Implementation

func can_interact(party: MapParty) -> bool:
	if not party: return false
	return true if contents else false

func accept_interaction(party: MapParty) -> int:
	state = ChestState.open
	_pick_up_items(party)
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

enum ChestState{
	closed,
	open,
	empty
}

var state: ChestState:
	get: return state
	set(value):
		($Closed.texture as AtlasTexture).region = _get_region_rect(value)
		state = value

const REGION_SIZE = Vector2(32., 32.)
const REGION_MARGIN = 3.0
const REGION_OFFSET = 42.0 - REGION_MARGIN

func _get_region_rect(s: ChestState) -> Rect2:
	return Rect2(
		Vector2(REGION_MARGIN + s * REGION_OFFSET, 0.),
		REGION_SIZE
	)
	

var contents: Array[MapItem]:
	get:
		var res: Array[MapItem] = []
		for c in $Contents.get_children():
			if c is MapItem: res.append(c)
		return res

func _pick_up_items(party: MapParty) -> void:
	party.pick_up(contents)
	state = ChestState.empty
