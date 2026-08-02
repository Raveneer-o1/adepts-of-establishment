@abstract
class_name AuraEffect
extends AppliedEffect

const _ADJACENT_POSITIONS: Array[int] = [ -2, -1, 1, 2 ]

@abstract func _apply_to(pos: int) -> void
@abstract func _remove_from(pos: int) -> void

func _get_affected_positions(relative_to: int = target_unit.party_position) -> Array[int]:
	var res: Array[int] = []
	for pos: int in _ADJACENT_POSITIONS.duplicate():
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
	for pos in _get_affected_positions(old_pos):
		_remove_from(pos)
	for pos in _get_affected_positions():
		_apply_to(pos)

func initialize(params: Variant = null, name_override := "") -> void:
	_signal_function_pairs[EventBus.unit_moved] = _check_move
	_signal_function_pairs[EventBus.units_moved] = _check_swap
	super.initialize(params, name_override)
	_apply_to_targets()

func activate() -> void:
	super.activate()
	_apply_to_targets()

func _apply_to_targets() -> void:
	for pos in _get_affected_positions():
		_apply_to.call_deferred(pos)  # deferring call to wait for unit initialization
