extends AppliedEffect

@export var type: GlobalDefs.UnitType
@export var effect: String
@export var passing_params: Variant

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 3: return
	type = params[0]
	effect = params[1]
	passing_params = params[2]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.type, other_effect.effect, other_effect.passing_params]
	return [type, effect, passing_params]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	if target_unit.unit_type == type:
		target_unit.parameters.apply_effect(effect, passing_params)
	queue_free()
