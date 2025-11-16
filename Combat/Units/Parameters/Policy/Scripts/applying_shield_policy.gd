extends BasePolicy

@export var durability: int = 50
## When [code]false[/code], [member durability] represents the number of hits
## the shield can block before breaking instead of total damage amount.
@export var is_measured_in_damage: bool = true
@export var percent_blocked: float = 0.5

@export var default_policy: BasePolicy

func give_sheild(unit: Unit) -> void:
	if not unit: return
	unit.parameters.apply_effect(
		"breakable_shield",
		[
			durability,
			is_measured_in_damage,
			percent_blocked,
		]
	)

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs: Array[UnitSpotReference] = []
	print(attack.target_references.size())
	for ref in attack.target_references:
		if not ref: continue
		if ref.spot.party == attack.attacker.party:
			if attack.is_primary_target(ref.spot):
				give_sheild(ref.spot.unit)
			continue
		new_refs.append(ref)
	if new_refs:
		attack.target_references = new_refs
		if default_policy:
			default_policy.apply_policy(attack, finalize)
		else:
			attack.standard_resolution(finalize)
