@abstract
class_name AuraEffect
extends AppliedEffect

const _ADJACENT_POSITIONS: Array[int] = [ -2, -1, 1, 2 ]

@abstract func _apply_to(pos: int) -> void
@abstract func _remove_from(pos: int) -> void

## Returns the encoded code for [param spot].
## For allies, the code is [member UnitSpot.party_position].
## For enemies, the code is [constant Party.MAX_UNITS_NUMBER] - [member UnitSpot.party_position].
## Use [method get_unit_spot] to decode it back.
## If [param spot] is [code]null[/code],
## returns [constant Party.MAX_UNITS_NUMBER] (an invalid code).
func encode_spot(spot: UnitSpot) -> int:
	if not spot: return Party.MAX_UNITS_NUMBER
	if spot.party == target_unit.party: return spot.party_position
	return spot.party_position - Party.MAX_UNITS_NUMBER

## Decodes the given [param pos] back into a [UnitSpot] reference.
## Returns [code]null[/code] if the code is invalid.
func get_unit_spot(pos: int) -> UnitSpot:
	if pos >= Party.MAX_UNITS_NUMBER: return null
	if pos < -Party.MAX_UNITS_NUMBER: return null
	if pos >= 0:
		return target_unit.party.unit_spots[pos]
	return target_unit.party.other_party.unit_spots[pos + Party.MAX_UNITS_NUMBER]

func _get_affected_positions(relative_to: int = target_unit.party_position) -> Array[int]:
	var res: Array[int] = []
	for pos: int in _ADJACENT_POSITIONS:
		var res_pos := pos + relative_to
		if res_pos >= 0 and res_pos < Party.MAX_UNITS_NUMBER:
			res.append(res_pos)
	return res

func _check_swap(first_unit: Unit, second_unit: Unit) -> void:
	_check_move(first_unit, second_unit.party_position)
	_check_move(second_unit, first_unit.party_position)

func _check_move(unit: Unit, old_pos: int) -> void:
	if not unit: return
	if unit == target_unit: _full_reapply(old_pos); return
	if unit.party != target_unit.party: return
	if old_pos in _get_affected_positions():
		_remove_from(unit.party_position)
		if unit.party_position in _get_affected_positions():
			_apply_to(unit.party_position)
	else:
		if unit.party_position in _get_affected_positions():
			_apply_to(unit.party_position)

func _full_reapply(old_pos: int) -> void:
	_remove_from_targets(old_pos)
	_apply_to_targets()

func initialize(params: Variant = null, name_override := "") -> void:
	_signal_function_pairs[EventBus.unit_moved] = _check_move
	_signal_function_pairs[EventBus.units_moved] = _check_swap
	super.initialize(params, name_override)
	_apply_to_targets()

func deactivate() -> void:
	super.deactivate()
	_remove_from_targets.call_deferred()  # deferring call to wait for unit initialization

func activate() -> void:
	super.activate()
	_apply_to_targets.call_deferred()  # deferring call to wait for unit initialization

func _remove_from_targets(relative_to: int = target_unit.party_position) -> void:
	for pos in _get_affected_positions(relative_to):
		_remove_from(pos)

func _apply_to_targets(relative_to: int = target_unit.party_position) -> void:
	for pos in _get_affected_positions(relative_to):
		_apply_to(pos)
