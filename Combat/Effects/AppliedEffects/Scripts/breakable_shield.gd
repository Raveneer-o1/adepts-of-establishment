extends AppliedEffect

@export var durability: int = 50
## When [code]false[/code], [member durability] represents the number of hits
## the shield can block before breaking instead of total damage amount.
@export var is_measured_in_damage: bool = true
@export var percent_blocked: float = 0.5

func _get_description() -> String:
	if is_measured_in_damage:
		return \
			"Blocks %d percent of incoming damage (can block %d damage in total before breaking)" % \
				[ roundi(percent_blocked * 100), durability ]
	return \
		"Blocks %d percent of incoming damage %d times" % \
			[ roundi(percent_blocked * 100), durability ]

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if durability <= 0:
		queue_free()
		return
	var refs := a.find_all_references(target_unit.spot)
	if not refs: return
	for ref  in refs:
		var original_dmg: int = a.damages[ref] if a.damages.has(ref) else a.default_damage
		@warning_ignore("narrowing_conversion")
		var blocked_dmg: int = roundi(original_dmg * percent_blocked)
		if is_measured_in_damage:
			if blocked_dmg > durability: blocked_dmg = durability
			durability -= blocked_dmg
		else:
			durability -= 1
		a.damages[ref] = original_dmg - blocked_dmg
		if durability <= 0: break
		continue
	if durability <= 0:
		lift_effect()

func _apply_effect(params: Variant) -> void:
	if params is not Array:
		push_error("Unxepected type passed to %s! Expected Array, got %s" % \
			[effect_name, type_string(typeof(params))])
		return
	if params.size() != 3:
		push_error("Unxepected number of arguments passed to %s! Expected 3, got %d" % \
			[effect_name, params.size()])
		return
	durability = params[0]
	is_measured_in_damage = params[1]
	percent_blocked = params[2]
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
