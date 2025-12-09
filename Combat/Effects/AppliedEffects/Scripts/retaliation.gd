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
	var attack_data := UnitAttackData.from_dict(parameters)
	attack_on_retaliation = UnitAttack.new()
	add_child(attack_on_retaliation)
	attack_on_retaliation.initialize(target_unit, attack_data)

func read_params(params: Variant) -> void:
	if params is Array:
		damage = params[0]
		read_attack(params[1])

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect:
		return [other_effect.damage, other_effect.attack_on_retaliation]
	return [damage, attack_on_retaliation]

func _apply_effect(params: Variant) -> void:
	read_params(params)
	attack_on_retaliation.unit = target_unit
	_signal_function_pairs[EventBus.attack_resolved] = check_trigger
