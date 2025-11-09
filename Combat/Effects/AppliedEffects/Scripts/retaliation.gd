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

func _apply_effect(params: Variant) -> void:
	if params is int:
		damage = params
	attack_on_retaliation.unit = target_unit
	_signal_function_pairs[EventBus.attack_resolved] = check_trigger
