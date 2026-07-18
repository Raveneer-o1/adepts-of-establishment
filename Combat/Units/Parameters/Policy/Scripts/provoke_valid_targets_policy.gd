extends BasePolicy

## Indicates period in rounds between using the ability
@export var period: int = 3
@export var damage_reduction: float = 0.5

@export var targets: BaseValidation

var cooldown: int = 0
var can_use_ability: bool:
	get: return cooldown <= 0

func use_ability(attack: Attack) -> void:
	EventBus.round_ended.connect(count_cooldown)
	cooldown = period
	attack.attacker.parameters.shielding = true
	for t in attack.attacker.system.find_valid_targets(targets, attack.attacker):
		if t.unit and t.unit.party != attack.attacker.party:
			t.unit.parameters.apply_effect(
				"forced_attack",
				[attack.attacker.spot],
				true,
				true
			).damage_reduction = damage_reduction

func count_cooldown() -> void:
	if cooldown > 0:
		cooldown -= 1
		return
	if EventBus.round_ended.is_connected(count_cooldown):
		EventBus.round_ended.disconnect(count_cooldown)

func _apply_policy(attack: Attack, finalize: bool) -> void:
	#var self_ref: UnitSpotReference = attack.find_reference(attack.attacker.spot)
	#if not self_ref:
		#attack.standard_resolution()
		#return
	if cooldown > 0: return
	if not targets:
		push_error("Unassigned target validation")
		return
	use_ability(attack)
