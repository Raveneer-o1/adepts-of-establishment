extends AppliedEffect

@export var type: GlobalDefs.UnitType
@export var effect: String
@export var passing_params: Variant

func _apply_effect(params: Variant) -> void:
	const arg_number := 3
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		type = params[0]
		effect = params[1]
		passing_params = params[2]
	if target_unit.unit_type == type:
		target_unit.parameters.apply_effect(effect, passing_params)
	queue_free()
