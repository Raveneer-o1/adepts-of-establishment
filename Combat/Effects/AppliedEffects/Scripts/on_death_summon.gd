extends AppliedEffect

@export var summon: Resource
## for description only
@export var unit_name: String
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
	
	# summoned unit does has summoned_unit flag set to false: this in intentional
	var unit := spot.add_unit(summon)
	
	for eff_name in effects:
		unit.parameters.apply_effect(eff_name, effects[eff_name])

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.unit_died] = check_trigger
