extends HeroAbility

## When [code]true[/code], smoothens multiplier results to get "pretty" numbers.
## When [code]false[/code], applies multipliers without rounding.
## Only applied to HP, damage and armor
@export var smoothen_values := true

@export_category("Multipliers")
@export var hp_multiplier := 1.1
@export var damage_multiplier := 1.1
@export var armor_multiplier := 1.0
@export var evasion_multiplier := 1.1
@export var shielding_chance_multiplier := 1.1

const HP_SMOOTH_FACTOR = 10.0
const DMG_SMOOTH_FACTOR = 5.0
const ARMOR_SMOOTH_FACTOR = 5.0

func _new_value(old_value: float, multiplier: float, factor: float = 1.0) -> float:
	if is_equal_approx(multiplier, 1.0): return old_value
	var new_val := old_value * multiplier
	if smoothen_values: new_val = roundf(new_val / factor) * factor
	return new_val

func _learn(hero: HeroData) -> void:
	if hero.level >= 10:
		unlimited_learning = false
		learned = true
	
	hero.max_hp = \
		int(_new_value(
			hero.max_hp,
			hp_multiplier,
			HP_SMOOTH_FACTOR
		))
	hero.base_damage = \
		int(_new_value(
			hero.base_damage,
			damage_multiplier,
			DMG_SMOOTH_FACTOR
		))
	hero.armor = \
		int(_new_value(
			hero.armor,
			armor_multiplier,
			ARMOR_SMOOTH_FACTOR
		))
	hero.evasion *= evasion_multiplier
	hero.shielding_chance *= shielding_chance_multiplier
	
