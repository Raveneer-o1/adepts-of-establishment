extends AuraEffect

@export var damage_increase: int = 5

const BUFF_ICON_INDEX = 5

var _added_effects: Dictionary[Unit, AppliedEffect] = {}

func _remove_from(pos: int) -> void:
	var unit := target_unit.party.unit_spots[pos].unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects.erase(unit)
	unit.update_visuals()

func _apply_to(pos: int) -> void:
	var unit := target_unit.party.unit_spots[pos].unit
	if not unit: return
	if is_instance_valid(_added_effects.get(unit)):
		_added_effects[unit].queue_free()
		_added_effects[unit] = null
	var eff := unit.parameters.apply_effect(
		"temporary_buff",
		{
			&"parameter" : "Attack",
			&"turns" : -1,
			&"strength" : damage_increase,
		},
		false,  # force_stackability
		false,  # override_stackability
		true    # silent
	)
	if not eff:
		GlobalLogger.force_message("Unable to apply the temporary", self)
		push_error("Unable to apply the effect")
		return
	eff.silencable = false
	eff.liftable = false
	_added_effects[unit] = eff
	unit.update_visuals()

func _get_description() -> String:
	return description % damage_increase

func read_params(params: Variant) -> void:
	if params is not int: return
	damage_increase = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.damage_increase
	return damage_increase
