
## IMPORTANT NOTE:
## When the game parses data from this file, it doesn't perform any verification.
## So, invalid structure of data (namely, incompatible data types) here may cause crashes.

func standart_healer_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
	
	# only attack if units are in the same party
	if attacker.party.units.has(target):
		return true
	return false


func standart_archer_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target):
		return false
	return true


func standart_melee_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target):
		return false
	
	var pos := attacker.party_position
	var targets : Array[Unit]
	# step of 2 indicates adjacent units *see Party class documentation*
	var step: int = 2
	
	# === Checking front line ===
	
	# even position indicates front line
	if pos % 2 == 0:
		# check position in front and adjacent positions
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
	
	# odd position indicates back line
	else:
		if not attacker.party.front_line_is_empty():
			return false
		# set new pos to check front line first
		step = -1
	
	
	# assuming we can't get out of bounds on the first check
	var in_bounds: bool = true
	while in_bounds:
		step += 2
		
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
		# if get_units_at_positions() returned 2 nulls, we're completely out of bouns
		if targets.size() == 2:
			in_bounds = false
	
	# === Checking back line ===
	
	# even position indicates front line
	if pos % 2 == 0:
		step = 1
	
	# odd position indicates back line
	else:
		step = 2
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
	
	
	in_bounds = true
	while in_bounds:
		targets = attacker.party.other_party.get_units_at_positions([pos - step, pos + step])
		if targets.has(target):
			return true
		
		# if at least one value returned is not null, target is blocked by that unit
		for u in targets:
			if u != null:
				return false
		
		# if get_units_at_positions() returned 2 nulls, we're completely out of bouns
		if targets.size() == 2:
			in_bounds = false
		
		step += 2
	
	return false


func standart_mage_validity(attacker: Unit, target: Unit) -> bool:
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target):
		return false
	
	return not attacker.chosen_targets.has(target)


func standart_mage_additional_targets(attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit]:
	#if chosen_targets.is_empty():
		#return []
	var all_units := attacker.party.other_party.get_units_custom(all_units_filter)
	var result: Array[Unit]
	for u in all_units:
		if not chosen_targets.has(u):
			result.append(u)
	return result


func standart_splash_additional_targets(attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit]:
	if chosen_targets.is_empty():
		return []
	var result := attacker.party.other_party.get_adjacent_units(attacker.chosen_targets[0].party_position)
	#print(result)
	return result


func standart_mass_healer_additional_targets(attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit]:
	var all_units := attacker.party.get_units_custom(all_units_filter)
	var result: Array[Unit]
	for u in all_units:
		if not chosen_targets.has(u):
			result.append(u)
	return result


func standart_decay_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	var first_position: int = attack.targets[0].party_position
	var decay_rate := 0.5
	var target := attack.targets[index]
	var distance:int = Party.get_distance(attack.attacker.party_position, target.party_position)
	attack.damage *= pow(decay_rate, distance)
	target.resolve_attack(attack, index + 1, finalize)


func standart_immediate_decay_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	var first_position: int = attack.targets[0].party_position
	var decay_rate := 0.5
	var target := attack.targets[index]
	var distance:int = Party.get_distance(attack.attacker.party_position, target.party_position)
	#print(distance)
	attack.damage *= pow(decay_rate, distance)
	target.resolve_attack(attack, index + 1, true)


func standart_immediate_resolution_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	attack.targets[index].resolve_attack(attack, finalize)


var DATABASE := {
	"EXAMPLE" = {
		Level = 999, # int
		Damage = 25, # int
		HP = 100, # int
		Armor = 0, # int
		Immunities = [ # Array[EventBus.AttackType]
			EventBus.AttackType.Physical,
			EventBus.AttackType.Elemental
		],
		Attacks = [ # Array[Dictionary]
			{
				DamageMultiplier = 1.0, # float
				DamageOverride = false, # bool
				Type = EventBus.AttackType.Physical, # EventBus.AttackType
				Accuracy = 0.8, # float [0, 1]
				TargetsNeeded = 1, # int
				Initiative = 40, # int
				Validation = standart_melee_validity, # Callable (attacker: Unit, target: Unit) -> bool
				FindAdditionalTargets = standart_mass_healer_additional_targets, # Callable (attacker: Unit, chosen_targets: Array[Unit]) -> Array[Unit]
				DamagePolicy = standart_decay_policy, # Callable (attack: Attack, index: int) -> void
			},
		]
	},
	"Squire" = {
		Level = 1, # int
		Damage = 25, # int
		HP = 100, # int
		Armor = 0, # int
		Attacks = [ # Array[Dictionary]
			{
				DamageMultiplier = 1.0, # float
				DamageOverride = false, # bool
				Type = EventBus.AttackType.Physical, # EventBus.AttackType
				Accuracy = 0.8, # float
				TargetsNeeded = 1, #int
				Initiative = 40, # int
				Validation = standart_melee_validity, # Callable (attacker: Unit, target: Unit) -> bool
			},
		]
	},
	"Witch hunter" = {
		Level = 2,
		Damage = 50,
		HP = 150,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 45,
				Validation = standart_melee_validity,
			},
		]
	},
	"Knight" = {
		Level = 2,
		Damage = 50,
		HP = 150,
		Armor = 10,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Samurai" = {
		Level = 3,
		Damage = 45,
		HP = 175,
		Armor = 5,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 2,
				Initiative = 55,
				Validation = standart_melee_validity,
			},
		]
	},
	"Inquisitor" = {
		Level = 3,
		Damage = 75,
		HP = 180,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.None,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Knight Master" = {
		Level = 3,
		Damage = 75,
		HP = 190,
		Armor = 15,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Horseman" = {
		Level = 3,
		Damage = 65,
		HP = 200,
		Armor = 10,
		Attacks = [
			{
				DamageMultiplier = 0.6,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_melee_validity,
			},
			{
				DamageMultiplier = 0.9,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Blade Saint" = {
		Level = 4,
		Damage = 100,
		HP = 200,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 2,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Grand Inquisitor" = {
		Level = 4,
		Damage = 100,
		HP = 220,
		Armor = 5,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.None,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 80,
				Validation = standart_melee_validity,
				FindAdditionalTargets = standart_splash_additional_targets,
				DamagePolicy = standart_immediate_decay_policy,
			},
		]
	},
	"Angel Knight" = {
		Level = 4,
		Damage = 100,
		HP = 250,
		Armor = 20,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Royal Cavalier" = {
		Level = 4,
		Damage = 90,
		HP = 200,
		Armor = 30,
		Attacks = [
			{
				DamageMultiplier = 0.6,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_melee_validity,
			},
			{
				DamageMultiplier = 0.9,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 45,
				Validation = standart_melee_validity,
			},
		]
	},
	"Paladin" = {
		Level = 5,
		Damage = 100,
		HP = 220,
		Armor = 30,
		Attacks = [
			{
				DamageMultiplier = 0.6,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_melee_validity,
			},
			{
				DamageMultiplier = 0.9,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 45,
				Validation = standart_melee_validity,
			},
		]
	},
	"Angel" = {
		Level = 5,
		Damage = 120,
		HP = 250,
		Armor = 10,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 30,
				Validation = standart_melee_validity,
			},
		]
	},
	"Apprentice" = {
		Level = 1,
		Damage = 25,
		HP = 60,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 30,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
			},
		],
		#DamagePolicy = 
	},
	"Elementalist" = {
		Level = 2,
		Damage = 45,
		HP = 110,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = standart_archer_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
			},
		],
	},
	"Mage" = {
		Level = 2,
		Damage = 40,
		HP = 120,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 30,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
				DamagePolicy = standart_decay_policy,
			},
		],
	},
	"Ritualist" = {
		Level = 3,
		Damage = 80,
		HP = 150,
		Armor = 5,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.85,
				TargetsNeeded = 2,
				Initiative = 60,
				Validation = standart_mage_validity,
			},
		]
	},
	"Wizard" = {
		Level = 3,
		Damage = 70,
		HP = 170,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
			},
		],
	},
	"White Mage" = {
		Level = 4,
		Damage = 80,
		HP = 190,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
				DamagePolicy = standart_decay_policy,
			},
		],
	},
	"Keeper of Knowledge" = {
		Level = 5,
		Damage = 95,
		HP = 210,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Mind,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
			},
		],
	},
	"Arcanist" = {
		Level = 5,
		Damage = 90,
		HP = 220,
		Armor = 15,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.95,
				TargetsNeeded = 1,
				Initiative = 30,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
			},
		],
	},
	"Archer" = {
		Level = 1,
		Damage = 25,
		HP = 70,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.75,
				TargetsNeeded = 1,
				Initiative = 50,
				Validation = standart_archer_validity,
			},
		]
	},
	"Marksman" = {
		Level = 2,
		Damage = 40,
		HP = 90,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 50,
				Validation = standart_archer_validity,
			},
		]
	},
	"Scout" = {
		Level = 3,
		Damage = 55,
		HP = 120,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = standart_archer_validity,
			},
		]
	},
	"Assassin" = {
		Level = 3,
		Damage = 35,
		HP = 150,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_archer_validity,
			},
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_archer_validity,
			},
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_archer_validity,
			},
		]
	},
	"Imperial Ranger" = {
		Level = 4,
		Damage = 90,
		HP = 200,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = standart_archer_validity,
			},
		]
	},
	"Acolyte" = {
		Level = 1,
		Damage = -20,
		HP = 90,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
			},
		]
	},
	"Cleric" = {
		Level = 2,
		Damage = -25,
		HP = 115,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
				FindAdditionalTargets = standart_mass_healer_additional_targets,
			},
		]
	},
	"Priest" = {
		Level = 2,
		Damage = -40,
		HP = 115,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
			},
		]
	},
	"Matriarch" = {
		Level = 3,
		Damage = -45,
		HP = 150,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
				FindAdditionalTargets = standart_mass_healer_additional_targets,
			},
		]
	},
	"Imperial priest" = {
		Level = 3,
		Damage = -70,
		HP = 155,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
			},
		]
	},
	"Prophetess" = {
		Level = 4,
		Damage = -75,
		HP = 190,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
				FindAdditionalTargets = standart_mass_healer_additional_targets,
			},
		]
	},
	"Hierophant" = {
		Level = 4,
		Damage = -110,
		HP = 195,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Life,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_healer_validity,
			},
		]
	},
}

#region Utilities

## Removes duplicate units from an array, maintaining the first occurrence.
func filter_duplicates(arr: Array[Unit]) -> Array[Unit]:
	var result: Array[Unit] = []
	for u in arr:
		if not result.has(u):
			result.append(u)
	return result


func all_units_filter(unit: Unit) -> bool:
	if unit == null:
		return false
	if unit.parameters.dead:
		return false
	return true

#endregion
