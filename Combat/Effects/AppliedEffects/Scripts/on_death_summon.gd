extends AppliedEffect

## for description only
@export var unit_name: String

@export var summon: Resource
@export var effects: Dictionary[String, Variant]

func _get_description() -> String:
	return description % unit_name

func check_trigger(u: Unit) -> void:
	if is_queued_for_deletion(): return
	if u != target_unit: return
	if not summon: return
	var avaliable_spots: Array[UnitSpot] = target_unit.party.unit_spots.filter(
		func(s: UnitSpot)->bool: return s.unit == null
	)
	if not avaliable_spots: return
	var spot: UnitSpot = avaliable_spots.pick_random()
	
	# summoned unit has summoned_unit flag set to false: this in intentional
	var unit := spot.add_unit(summon, null)
	
	for eff_name in effects:
		unit.parameters.apply_effect(eff_name, effects[eff_name])

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 2: return
	summon = load(params[0])
	effects = params[1]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.summon.resource_path, other_effect.effects]
	return [summon.resource_path, effects]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	_signal_function_pairs[EventBus.unit_died] = check_trigger
