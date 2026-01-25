extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description

@export var attack_buff := .02
@export var buff_chance := .3

@export var message := "Legion stand"

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if a.attacker != target_unit: return
	if not GlobalDefs.rand_roll(buff_chance, target_unit.party): return
	
	var params: Dictionary = {
		"parameter": "base_damage",
		"turns": -1,
		"multiplier": 1.0 + attack_buff,
		"strength": 1  # at least +1 attack
	}
	var effect := (target_unit.party.all_units.pick_random() as Unit)\
		.parameters.apply_effect("temporary_buff", params)
	#effect.liftable = false
	effect.silencable = false
	effect.make_persistent()

func read_params(params: Variant) -> void:
	const arg_number = 2
	if params is Array:
		if params.size() != arg_number:
			push_error("Unxepected number of agruments passed to %s! Expected %d, got %d" % \
				[effect_name, arg_number, params.size()]
			)
			queue_free()
			return
		buff_chance = params[0]
		attack_buff = params[1]

var _resurrected_this_combat := false

func check_resurrection(u: Unit) -> void:
	if _resurrected_this_combat: return
	if is_queued_for_deletion(): return
	if u.party != target_unit.party: return
	u.resurrect(message)
	@warning_ignore("integer_division")
	u.heal(u.parameters.max_hp / 3)

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [other_effect.buff_chance, other_effect.attack_buff]
	return [buff_chance, attack_buff]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
	_signal_function_pairs[EventBus.unit_died] = check_resurrection
