class_name MapTrigger_OnEnterArea
extends MapTrigger

## If the pin is place on an area, the entire are will serve as a trigger
## (see [ZonesLayer]).
@export var pin: MapPin
## If [code]true[/code], stops the party that activated the trigger.
@export var stop_movement := false

var area_of_interest: Array[Vector2i]

func _check_trigger(party: MapParty) -> void:
	if not active: return
	if not party: return
	if party.tile_position not in area_of_interest: return
	if stop_movement: party.control.abort_moving()
	trigger()

func _initialize() -> void:
	if not await _set_area_of_interest(): return
	EventBus.party_moved.connect(_check_trigger)

func _set_area_of_interest() -> bool:
	if not pin: queue_free(); return false
	if not pin.is_node_ready(): await pin.ready
	area_of_interest = map.zones_layer.get_area(pin.tile_position)
	if not area_of_interest: area_of_interest.append(pin.tile_position)
	return true
