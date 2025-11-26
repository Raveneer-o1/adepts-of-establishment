extends AppliedEffect

@export var damage: int = 50
@export var attack_on_retaliation: UnitAttack

const appended_tag = &"returned"

func _get_description() -> String:
	return description % damage

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return
	if a.attacker.party == target_unit.party: return
	if a.tags.has(appended_tag): return
	if target_unit not in a.targets: return
	var attack := Attack.new(attack_on_retaliation, [a.attacker.spot], damage)
	attack.tags.append(appended_tag)
	target_unit.system.combat_logic.book_damage(attack, false)

func read_attack(parameters: Dictionary) -> void:
	if attack_on_retaliation: attack_on_retaliation.queue_free()
	attack_on_retaliation = UnitAttack.new()
	attack_on_retaliation.damage_multiplier = parameters["damage_multiplier"]
	attack_on_retaliation.damage_override = parameters["damage_override"]
	attack_on_retaliation.is_heal = parameters["is_heal"]
	attack_on_retaliation.type = parameters["type"]
	attack_on_retaliation.accuracy = parameters["accuracy"]
	attack_on_retaliation.targets_needed = parameters["targets_needed"]
	attack_on_retaliation.initiative = parameters["initiative"]
	attack_on_retaliation.evadable = parameters["evadable"]
	attack_on_retaliation.tags = parameters["tags"]
	attack_on_retaliation.target_validation = load(parameters["target_validation"])
	attack_on_retaliation.additional_targets = load(parameters["additional_targets"]) if parameters["additional_targets"] else null
	attack_on_retaliation.damage_policy = load(parameters["damage_policy"]) if parameters["damage_policy"] else null
	attack_on_retaliation.applying_effects = parameters["applying_effects"]

func read_params(params: Variant) -> void:
	if params is Array:
		damage = params[0]
		read_attack(params[1])

func construct_attack_dict(a: UnitAttack) -> Dictionary:
	var res := {
		"damage_multiplier" = a.damage_multiplier,
		"damage_override" = a.damage_override,
		"is_heal" = a.is_heal,
		"type" = a.type,
		"accuracy" = a.accuracy,
		"targets_needed" = a.targets_needed,
		"initiative" = a.initiative,
		"evadable" = a.evadable,
		"tags" = a.tags,
		"target_validation" = a.target_validation.resource_path if a.target_validation else "",
		"additional_targets" = a.additional_targets.resource_path if a.additional_targets else "",
		"damage_policy" = a.damage_policy.resource_path if a.damage_policy else "",
		"applying_effects" = a.applying_effects,
	}
	return res

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect:
		return [other_effect.damage, construct_attack_dict(other_effect.attack_on_retaliation)]
	return [damage, construct_attack_dict(attack_on_retaliation)]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	attack_on_retaliation.unit = target_unit
	_signal_function_pairs[EventBus.attack_resolved] = check_trigger
