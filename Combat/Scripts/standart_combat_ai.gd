extends Node

const RATIO_LOW_THRESHOLD = 2.0
const RATIO_HIGH_THRESHOLD = 7.0

# If difference is less than this values, they will be treated as the same value.
# e.g. if two units have ratios 3.2 and 3.3, AI will not
# prioritize one over the other based on this fact alone
const RATIO_EPSILON = 1.0
const DAMAGE_EPSILON = 40

@onready var api: PlayerAPI = get_parent()

var units_ratio := {}
var units_damage_potential := {}
var units_damage := {}

var prioritized_units: Array[Unit] = []


# Calculating HP/Damage ratio for all Enemy units
func calculate_ratio() -> void:
	units_ratio.clear()
	var enemy_units := api.party.other_party.units
	for unit in enemy_units:
		if unit == null or unit.parameters.dead:
			continue
		units_ratio[unit] = float(unit.parameters.effective_current_hp) / float(unit.parameters.get_full_damage())


## Calculates full damage potential for all ally units and writes it in
## [member units_damage_potential] Dictionary.
func calculate_damage_potential() -> void:
	units_damage_potential.clear()
	for unit in api.party.units:
		if unit == null or unit.parameters.dead:
			continue
		units_damage_potential[unit] = unit.parameters.get_full_damage()

## Calculates maximum damage each enemy unit could take and writes it in
## [member units_damage] Dictionary.
func calculate_damage() -> void:
	units_damage.clear()
	for unit in api.party.units:
		if unit == null or unit.parameters.dead:
			continue
		
		for attack in unit.parameters.attacks:
			var avaliable_tagrts := api.combat_system.find_targets_for_attack(attack)
			for target in avaliable_tagrts:
				if units_damage.has(target.unit):
					units_damage[target.unit] += unit.parameters.get_actual_damage(attack)
				else:
					units_damage[target.unit] = unit.parameters.get_actual_damage(attack)



func sorting_by_ratio(u1: Unit, u2: Unit) -> bool:
	# if u1 has no possible damage, lower its priority
	if not (units_damage.has(u1)):
		return false
	
	# if u2 has no possible damage, don't lower the priority of u1
	if not (units_damage.has(u2)):
		return true
	
	var result_ratio: bool = units_ratio[u1] <= units_ratio[u2]
	var result_damage: bool = units_damage[u1] > units_damage[u2]
	
	if result_ratio and result_damage:
		return true
	
	var ratio_diff : int = abs(units_ratio[u2] - units_ratio[u1])
	var damage_diff : int = abs(units_damage[u2] - units_damage[u1])
	
	if ratio_diff < RATIO_EPSILON and damage_diff > DAMAGE_EPSILON:
		return result_damage
	
	if damage_diff < DAMAGE_EPSILON and ratio_diff > RATIO_EPSILON:
		return result_ratio
	
	return result_ratio

## Calculates [member prioritized_units] as an Array sorted by the priority
func set_policy() -> void:
	calculate_ratio()
	calculate_damage_potential()
	calculate_damage()
	
	prioritized_units.clear()
	var high_priority_units: Array[Unit] = []
	var low_priority_units: Array[Unit] = []
	var units: Array[Unit] = []
	
	
	# STEP 1. Filter units with ratios below/above thresholds
	# =======
	
	for unit: Unit in units_ratio:
		if units_ratio[unit] <= RATIO_LOW_THRESHOLD:
			high_priority_units.append(unit)
			continue
		if units_ratio[unit] >= RATIO_HIGH_THRESHOLD:
			low_priority_units.append(unit)
			continue
		units.append(unit)
	
	# If we found units with high priority, add them to the list
	if not high_priority_units.is_empty():
		high_priority_units.sort_custom(sorting_by_ratio)
		prioritized_units = high_priority_units
		high_priority_units = []
	
	
	# STEP 2. Units that can be killed before they attack this turn, should be prioritized
	# =======
	
	var units_left := units
	units = []
	for unit: Unit in units_left:
		if units_damage.has(unit):
			if units_damage[unit] >= unit.parameters.effective_current_hp:
				high_priority_units.append(unit)
				continue
		
		units.append(unit)
	
	# If we found units with high priority, add them to the list
	if not high_priority_units.is_empty():
		high_priority_units.sort_custom(
				func(u1: Unit, u2: Unit) -> bool:
					# if u1 has no possible damage, lower its priority
					if not (units_damage.has(u1)):
						return false
					
					# if u2 has no possible damage, don't lower the priority of u1
					if not (units_damage.has(u2)):
						return true
					
					return u1.parameters.base_damage > u2.parameters.base_damage
		)
		prioritized_units.append_array(high_priority_units)
		high_priority_units = []
	
	
	
	
	# STEP 3. Units of certain types (e.g. healers) are more valuable as a target
	# =======
	
	units_left = units
	units = []
	var priority_types := ["Healer", "Debuffer", "Buffer"]
	for unit in units_left:
		if priority_types.has(unit.unit_type):
			prioritized_units.append(unit)
			continue
		units.append(unit)
	
	
	
	# STEP 4. Prioritizing units to which we can do most damage
	# =======
	
	units.sort_custom(
			func (u1: Unit, u2: Unit) -> bool:
				# if u2 has no possible damage, don't lower the priority of u1
				if not (units_damage.has(u2)):
					return false
				
				# if u1 has no possible damage, lower its priority
				if not (units_damage.has(u1)):
					return true
				
				return units_damage[u1] > units_damage[u2]
	)
	prioritized_units.append_array(units)
	
	# STEP 5. Adding low priority units to the end of a list
	prioritized_units.append_array(low_priority_units)


func evaluate_targets(ai_unit: Unit, valid_targets: Array[UnitSpot]) -> UnitSpot:
	if valid_targets.is_empty():
		return null
	
	#print(prioritized_units)
	for unit in prioritized_units:
		if valid_targets.has(unit.spot):
			#print(unit)
			#print("------")
			return unit.spot
	
	return valid_targets.pick_random()


func find_target_for_healing(valid_targets: Array[UnitSpot]) -> UnitSpot:
	var result: UnitSpot = null
	var result_percenage: float = 1.0 # initializing to value 1 so the we won't choose full hp units
	
	for target in valid_targets:
		if target == null or target.unit == null:
			continue
		
		if target.unit.parameters.dead:
			return target
		
		var percentage : float = target.unit.parameters.hp_percentage
		if percentage < result_percenage:
			result_percenage = percentage
			result = target
	
	return result


func choose_warrior_action(unit: Unit, avaliable_targets: Array[UnitSpot]) -> void:
	var targets_need := unit.current_attack.targets_needed
	
	while targets_need > 0:
		if avaliable_targets.is_empty():
			api.start_attack()
			return
		
		var chosen_unit := evaluate_targets(unit, avaliable_targets)
		api.choose_unit(chosen_unit)
		avaliable_targets = api.combat_system.find_avaliable_targets(unit)
		targets_need -= 1



func choose_healer_action(unit: Unit, avaliable_targets: Array[UnitSpot]) -> void:
	var targets_need := unit.current_attack.targets_needed
	while targets_need > 0:
		if avaliable_targets.is_empty():
			api.start_attack()
			return
		
		var chosen_unit := find_target_for_healing(avaliable_targets)
		if chosen_unit == null:
			api.use_defense_or_attack()
		
		api.choose_unit(chosen_unit)
		avaliable_targets = api.combat_system.find_avaliable_targets(unit)
		targets_need -= 1


func choose_action(unit: Unit) -> void:
	if unit == null:
		return
	if unit.party != api.party:
		return
	if unit.skipping_turn:
		return
	
	var avaliable_targets := api.combat_system.find_avaliable_targets()
	if avaliable_targets.is_empty():
		api.use_defense_stance()
	
	if unit.unit_type == "Healer":
		choose_healer_action(unit, avaliable_targets)
		return
	
	choose_warrior_action(unit, avaliable_targets)


func _ready() -> void:
	api._turn_started.connect(choose_action)
	EventBus.round_started.connect(set_policy)
