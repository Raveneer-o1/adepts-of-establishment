extends BasePolicy

@export var min_turns: int = 1
@export var random_additional_turns: int = 10

var turns: int
var unit: Unit

# argument to match signal signature
func check_turn(u: Unit = null) -> void:
	if not unit: return
	turns -= 1
	if turns > 0: return
	_return_unit()

func _return_unit() -> void:
	var available_spots: Array[UnitSpot] = unit.party.unit_spots.filter(
		func(s: UnitSpot)->bool: return s.unit == null
	)
	if not available_spots: return
	var spot: UnitSpot = available_spots.pick_random()
	spot.assign_unit(unit)
	unit = null
	if EventBus.turn_ended.is_connected(check_turn):
		EventBus.turn_ended.disconnect(check_turn)

# argument to match signal signature
func _check_if_last(u: Unit = null) -> void:
	if not unit: return
	if unit.party.check_if_empty():
		_return_unit()

func _apply_policy(attack: Attack, finalize: bool) -> void:
	if unit: return
	for ref in attack.target_references:
		if not ref: continue
		var u := ref.spot.unit
		if not u: continue
		unit = u
		u.deactivate()
		turns = min_turns
		if random_additional_turns > 0:
			turns += randi_range(0, random_additional_turns)
		EventBus.turn_ended.connect(check_turn)
		EventBus.unit_died.connect(_check_if_last)
		_check_if_last()
		return
