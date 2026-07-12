extends AppliedEffect

@export var durability: int = 50
## When [code]false[/code], [member durability] represents the number of hits
## the shield can block before breaking instead of total damage amount.
@export var is_measured_in_damage: bool = true
@export var percent_blocked: float = 0.5
@export var block_chance: float = 0.3

## [code]-1[/code] for unlimited triggers
@export var shields_left: int = -1

## Visual effect instantiated above this unit when the shield is triggered.
## The instantiated scene is not freed automatically.
## It's recommended to use [TemporaryEffect] scenes vor visuals
@export_file_path("*.tscn") var visual_path: String
var visual: PackedScene = null:
	get:
		if visual: return visual
		if FileAccess.file_exists(visual_path):
			print("loading visual")
			visual = load(visual_path)
			return visual
		return null
## Visual effect instantiated above shielded unit when the shield is triggered.
## The instantiated scene is not freed automatically.
## It's recommended to use [TemporaryEffect] scenes vor visuals.
@export_file_path("*.tscn") var shield_visual_path: String
var shield_visual: PackedScene = null:
	get:
		if shield_visual: return shield_visual
		if FileAccess.file_exists(shield_visual_path):
			print("loading shield")
			shield_visual = load(shield_visual_path)
			return shield_visual
		return null

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
		if visual and visual.can_instantiate():
			target_unit.add_child(visual.instantiate())
		if shield_visual and shield_visual.can_instantiate():
			unit.add_child(shield_visual.instantiate())
		if shields_left > 0: shields_left -= 1

func read_params(params: Variant) -> void:
	if params is not Array: return
	if params.size() != 7: return
	durability = params[0]
	is_measured_in_damage = params[1]
	percent_blocked = params[2]
	block_chance = params[3]
	shields_left = params[4]
	visual_path = params[5]
	shield_visual_path = params[6]

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return [
			other_effect.durability,
			other_effect.is_measured_in_damage,
			other_effect.percent_blocked,
			other_effect.block_chance,
			other_effect.shields_left,
			other_effect.visual_path,
			other_effect.shield_visual_path
		]
	return [
		durability,
		is_measured_in_damage,
		percent_blocked,
		block_chance,
		shields_left,
		visual_path,
		shield_visual_path
	]

func _apply_effect(params: Variant) -> void:
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
