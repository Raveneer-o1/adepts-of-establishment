extends Node

@onready var api: PlayerAPI = get_parent()


func evaluate_targets(ai_unit: Unit, valid_targets: Array[UnitSpot]) -> UnitSpot:
	var best_target: UnitSpot = null
	var highest_score: float = -INF
	
	for target in valid_targets:
		var score: float = 0
		
		# Base scoring
		var evaluation: float = evaluate_health(target.unit, ai_unit.parameters.base_damage)
		#print("%s's health evaluated as %f" % [target.unit.unit_name, evaluation])
		score += evaluation
		
		evaluation = evaluate_threat(target.unit)
		#print("%s's threat evaluated as %f" % [target.unit.unit_name, evaluation])
		score += evaluation
		
		# Check if this is the best target so far
		if score > highest_score:
			highest_score = score
			best_target = target
	
	return best_target

const HP_NORMALIZING_FACTOR = 100.0
const THREAT_NORMALIZING_FACTOR = 0.7

# Evaluate the target's health to prioritize finishing weak enemies
func evaluate_health(target: Unit, damage: float) -> float:
	if target == null:
		return 0.0
	if target.parameters.hp < damage:
		return HP_NORMALIZING_FACTOR
	var hp_percentage: float = float(target.parameters.hp) / float(target.parameters.max_hp)
	var evaluation: float = 1.0 - hp_percentage
	if target.defence_stance:
		evaluation /= 2.0
	return evaluation * HP_NORMALIZING_FACTOR

# Evaluate threat level based on the target's role and damage output
func evaluate_threat(target: Unit) -> float:
	if target == null:
		return 0.0
	var base_dmg: float = target.parameters.base_damage
	var threat_score: float = 0.0
	for attack: UnitAttack in target.parameters.attacks:
		var additional_score: float = \
				attack.damage_multiplier if attack.damage_override else \
				attack.damage_multiplier * base_dmg
		threat_score += additional_score * attack.targets_needed
	return threat_score * THREAT_NORMALIZING_FACTOR


func choose_action(unit: Unit) -> void:
	if unit == null:
		return
	if unit.party != api.party:
		return
	
	var avaliable_targets := api.combat_system.find_avaliable_targets()
	if avaliable_targets.is_empty():
		api.use_defense_stance()
	
	var targets_need := unit.current_attack.targets_needed
	while targets_need > 0:
		if avaliable_targets.is_empty():
			api.start_attack()
			return
		var chosen_unit := evaluate_targets(unit, avaliable_targets)
		api.choose_unit(chosen_unit)
		avaliable_targets = api.combat_system.find_avaliable_targets(unit)
		targets_need -= 1

func _ready() -> void:
	api.turn_started.connect(choose_action)
