extends AppliedEffect

@export var unit: Unit = null

var state_before_transformation: UnitState

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return

func read_params(params: Variant) -> void:
	const arg_number = 1
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		unit = params[0]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	# Although serialization doesn't preserve object references, this method must
	# return valid references for all objects the effect requires
	
	if other_effect: return [other_effect.unit]
	return [unit]

func _apply_effect(params: Variant) -> void:
	if not unit: return
	state_before_transformation = UnitState.new(target_unit)
	var state := UnitState.new(unit)
	state.change_unit_state(target_unit)
	state.queue_free()

func _remove_effect() -> void:
	state_before_transformation.change_unit_state(target_unit)
