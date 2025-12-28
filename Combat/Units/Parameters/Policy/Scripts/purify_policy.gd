extends BasePolicy

#@export var chance_to_purify_enemy: float = 0.5
#@export var melee_validity: BaseValidation

func purify(unit: Unit) -> void:
	for effect in unit.parameters.get_all_effects():
		effect.lift_effect()

func _apply_policy(attack: Attack, finalize: bool) -> void:
	var new_refs: Array[UnitSpotReference] = []
	var units_to_purify: Array[Unit] = []
	for ref in attack.target_references:
		if not (ref and ref.spot and ref.spot.unit): continue
		purify(ref.spot.unit)
