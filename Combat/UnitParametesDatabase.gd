
#region Validation

func standart_healer_validity(attacker: Unit, target: UnitSpot) -> bool:
	if attacker == null or target == null or target.unit == null:
		return false
	if target.unit.parameters.dead:
		return false
	
	# only attack if units are in the same party
	if attacker.party.units.has(target.unit):
		return true
	return false


func standart_archer_validity(attacker: Unit, target: UnitSpot) -> bool:
	if attacker == null or target == null or target.unit == null:
		return false
	if target.unit.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target.unit):
		return false
	return true


func standart_melee_validity(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null or target_spot == null or target_spot.unit == null:
		return false
	if target_spot.unit.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target_spot.unit):
		return false
	
	var target := target_spot.unit
	# TODO: make another algothithm for large units
	var pos := attacker.party_position if \
			not attacker.parameters.large_unit else \
			attacker.party_position + 1
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


func standart_mage_validity(attacker: Unit, target_spot: UnitSpot) -> bool:
	var target := target_spot.unit
	if attacker == null or target == null:
		return false
	if target.parameters.dead:
		return false
		
	# if units are in the same party, we don't attack
	if attacker.party.units.has(target):
		return false
	
	return not attacker.chosen_targets.has(target)

func standart_summoner_validity(attacker: Unit, target_spot: UnitSpot) -> bool:
	if attacker == null:
		return false
	if target_spot.unit != null:
		return false
	if target_spot.party != attacker.party:
		return false
	
	return true

#endregion

#region Additional targets

func standart_mage_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	#if chosen_targets.is_empty():
		#return []
	var all_units := attacker.party.other_party.get_units_custom(all_units_filter)
	var result: Array[UnitSpot]
	for u in all_units:
		if u.get_parent():
			result.append(u.spot)
	return result


func standart_splash_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	if chosen_targets.is_empty():
		return []
	var result_units := attacker.party.other_party.get_adjacent_units(attacker.chosen_targets[0].party_position)
	var result: Array[UnitSpot]
	for unit in result_units:
		result.append(unit.spot)
	return result


func standart_mass_healer_additional_targets(attacker: Unit, chosen_targets: Array[UnitSpot]) -> Array[UnitSpot]:
	var all_units := attacker.party.get_units_custom(all_units_filter)
	var result: Array[UnitSpot]
	for u in all_units:
		if not chosen_targets.has(u.get_parent()):
			result.append(u.get_parent())
	return result
#endregion

#region Policies

func standart_decay_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	var first_position: int = attack.targets[0].party_position
	var decay_rate := 0.5
	var target := attack.targets[index]
	var distance:int = Party.get_distance(first_position, target.party_position)
	@warning_ignore("narrowing_conversion") attack.damage *= pow(decay_rate, distance)
	target.resolve_attack(attack, index + 1, finalize)


func standart_immediate_decay_policy(attack: Attack, index: int, _finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	var first_position: int = attack.targets[0].party_position
	var decay_rate := 0.5
	var target := attack.targets[index]
	var distance:int = Party.get_distance(first_position, target.party_position)
	#print(distance)
	@warning_ignore("narrowing_conversion") attack.damage *= pow(decay_rate, distance)
	target.resolve_attack(attack, index + 1, true)


func standart_immediate_resolution_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.targets.is_empty():
		return
	if index < 0 or index >= attack.targets.size():
		return
	attack.targets[index].resolve_attack(attack, finalize)


func elemantalist_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots.is_empty():
		return
	if index < 0 or index >= attack.target_spots.size():
		return
	var spot := attack.target_spots[index]
	if spot == null:
		return
	var attacker := attack.attacker
	if spot.party == attack.attacker.party:
		if attacker.parameters.other_effects.is_empty():
			print_debug("No Elemental prefab found!")
			return
		spot.add_unit(attacker.parameters.other_effects[0])
		return
	
	if spot.unit == null:
		return
	
	spot.unit.resolve_attack(attack, index, finalize)

#endregion


# IMPORTANT NOTE:
# The game does not validate the data structure or types when parsing this file. 
# Any invalid structure (e.g., incompatible data types) may lead to crashes.

# If a value is missing for a particular field, the game assigns a default value.
# The exact default values are currently unspecified (see UnitParameters.set_parameters).

# For attack effects, the expected structure is a Dictionary, where each pair is:
# <name, params> (<String, Variant>).
# - "name" specifies the name of the effect's scene.
# - "params" provides any additional parameters required by the effect.
# The exact type and structure of "params" are determined by the respective effect classes.

# NOTE: This applies only to effects inflicted by attacks on enemy units.
# To define effects that passively affect the attacking unit (e.g., abilities or passive traits), 
# add the relevant nodes directly to the unit's scene. Alternatively, use 
# UnitParameters.apply_effect(), but avoid this method for permanent statuses.

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
				Effects = {"poison" = 35}, # Array[String]
			},
		]
	},
	"Squire" = {
		Level = 1, # int
		Damage = 30, # int
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
		Damage = 30,
		HP = 150,
		Armor = 10,
		Attacks = [
			{
				DamageMultiplier = 1.33,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.82,
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
	"Samurai" = {
		Level = 3,
		Damage = 35,
		HP = 185,
		Armor = 20,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.875,
				TargetsNeeded = 2,
				Initiative = 45,
				Validation = standart_melee_validity,
			},
		]
	},
	"Inquisitor" = {
		Level = 3,
		Damage = 40,
		HP = 190,
		Armor = 25,
		Attacks = [
			{
				DamageMultiplier = 1.5,
				DamageOverride = false,
				Type = EventBus.AttackType.None,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Knight Master" = {
		Level = 3,
		Damage = 70,
		HP = 200,
		Armor = 30,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Horseman" = {
		Level = 3,
		Damage = 40,
		HP = 200,
		Armor = 20,
		Attacks = [
			{
				DamageMultiplier = 0.6,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_melee_validity,
			},
			{
				DamageMultiplier = 0.9,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Blade Saint" = {
		Level = 4,
		Damage = 35,
		HP = 220,
		Armor = 0,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.9,
				TargetsNeeded = 2,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Grand Inquisitor" = {
		Level = 4,
		Damage = 80,
		HP = 225,
		Armor = 40,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.None,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
				FindAdditionalTargets = standart_splash_additional_targets,
				DamagePolicy = standart_immediate_decay_policy,
				Effects = {"stun" = [0.3, 1]}
			},
		]
	},
	"Angel Knight" = {
		Level = 4,
		Damage = 90,
		HP = 230,
		Armor = 50,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_melee_validity,
			},
		]
	},
	"Royal Cavalier" = {
		Level = 4,
		Damage = 55,
		HP = 230,
		Armor = 40,
		Attacks = [
			{
				DamageMultiplier = 0.6,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_melee_validity,
			},
			{
				DamageMultiplier = 0.9,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 45,
				Validation = standart_melee_validity,
			},
		]
	},
	"Paladin" = {
		Level = 5,
		Damage = 65,
		HP = 250,
		Armor = 55,
		Attacks = [
			{
				DamageMultiplier = 0.6,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 70,
				Validation = standart_melee_validity,
			},
			{
				DamageMultiplier = 0.9,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.86,
				TargetsNeeded = 1,
				Initiative = 45,
				Validation = standart_melee_validity,
			},
		]
	},
	"Angel" = {
		Level = 5,
		Damage = 110,
		HP = 250,
		Armor = 30,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 30,
				Validation = standart_melee_validity,
			},
		]
	},
	"Apprentice" = {
		Level = 1,
		Damage = 22,
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
		Damage = 50,
		HP = 110,
		Armor = 5,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = func (attacker: Unit, target_spot: UnitSpot):
					return standart_mage_validity(attacker, target_spot) or \
							standart_summoner_validity(attacker, target_spot),
				#FindAdditionalTargets = standart_mage_additional_targets,
				DamagePolicy = elemantalist_policy,
			},
		],
	},
	"Mage" = {
		Level = 2,
		Damage = 40,
		HP = 120,
		Armor = 10,
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
		Armor = 10,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.85,
				TargetsNeeded = 2,
				Initiative = 60,
				Validation = func (attacker: Unit, target_spot: UnitSpot):
					return standart_mage_validity(attacker, target_spot) or \
							standart_summoner_validity(attacker, target_spot),
				#FindAdditionalTargets = standart_mage_additional_targets,
				DamagePolicy = elemantalist_policy,
			},
		]
	},
	"Wizard" = {
		Level = 3,
		Damage = 70,
		HP = 170,
		Armor = 10,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.81,
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
		Armor = 15,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.82,
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
		Damage = 60,
		HP = 210,
		Armor = 15,
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
		Armor = 30,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 0.84,
				TargetsNeeded = 1,
				Initiative = 30,
				Validation = standart_mage_validity,
				FindAdditionalTargets = standart_mage_additional_targets,
				DamagePolicy = standart_decay_policy,
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
		Armor = 5,
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
				DamageMultiplier = 0.5,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = standart_archer_validity,
			},
			{
				DamageMultiplier = 0.5,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.8,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_archer_validity,
			},
		]
	},
	"Assassin" = {
		Level = 3,
		Damage = 15,
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
				Effects = {"poison" = [45, 3]}, # Array[String]
			},
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 40,
				Validation = standart_archer_validity,
				Effects = {"poison" = [55, 2]}, # Array[String]
			},
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.85,
				TargetsNeeded = 1,
				Initiative = 20,
				Validation = standart_archer_validity,
				Effects = {"poison" = [65, 1]}, # Array[String]
			},
		]
	},
	"Imperial Ranger" = {
		Level = 4,
		Damage = 60,
		HP = 200,
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
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 0.9,
				TargetsNeeded = 1,
				Initiative = 40,
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
	
	"Elemental" = {
		Level = 1,
		Damage = 50,
		HP = 100,
		Armor = 0,
		Immunities = [
			EventBus.AttackType.Elemental
		],
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Elemental,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = standart_archer_validity,
			},
		]
	},
	
	"Dracolich" = {
		Level = 5,
		Damage = 110,
		HP = 500,
		Armor = 50,
		Attacks = [
			{
				DamageMultiplier = 1.0,
				DamageOverride = false,
				Type = EventBus.AttackType.Physical,
				Accuracy = 1.0,
				TargetsNeeded = 1,
				Initiative = 60,
				Validation = standart_melee_validity,
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
