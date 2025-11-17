extends AppliedEffect

@export var durability: int = 50
## When [code]false[/code], [member durability] represents the number of hits
## the shield can block before breaking instead of total damage amount.
@export var is_measured_in_damage: bool = true
@export var percent_blocked: float = 0.5
@export var block_chance: float = 0.3

## [code]-1[/code] for unlimited triggers
@export var shields_left: int = -1

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	var protected_units := target_unit.party.get_adjacent_units(target_unit.party_position)
	var attacked_units := a.targets
	for u in protected_units:
		if u in attacked_units and GlobalDefs.rand_roll(block_chance, target_unit.party):
			give_sheild(u)
	if shields_left == 0:
		lift_effect()

func give_sheild(unit: Unit) -> void:
	if not unit: return
	if shields_left == 0: return
	
	if unit.parameters.apply_effect(
		"breakable_shield",
		[
			durability,
			is_measured_in_damage,
			percent_blocked,
		],
		true,  # force_stackability
		true  # override_stackability
	):
		if shields_left > 0: shields_left -= 1

func _apply_effect(params: Variant) -> void:
	if params is Array:
		if params.size() != 5:
			push_error("Unxepected number of arguments passed to %s! Expected 5, got %d" % \
				[effect_name, params.size()])
			return
		durability = params[0]
		is_measured_in_damage = params[1]
		percent_blocked = params[2]
		block_chance = params[3]
		shields_left = params[4]
	
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
