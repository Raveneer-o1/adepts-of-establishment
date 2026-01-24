extends HeroAbility

## When [code]true[/code], smoothens multiplier results to get "pretty" numbers.
## When [code]false[/code], applies multipliers without rounding.
@export var smoothen_values := true

@export var damage_multiplier := 0.65

@export var attack_dict := {
	"attack_name" = "Attack",
	"damage_multiplier" = 1.0,
	"damage_override" = false,
	"is_heal" = false,
	"type" = GlobalDefs.AttackType.Elemental,
	"accuracy" = 0.95,
	"targets_needed" = 1,
	"initiative" = 40,
	"evadable" = true,
	"tags" = [],
	"target_validation" = "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres",
	"additional_targets" = "",
	"damage_policy" = "",
	"applying_effects" = {},
	"alternative_actions" = [],
}

const DMG_SMOOTH_FACTOR = 5.0

func _new_value(old_value: float, multiplier: float, factor: float = 1.0) -> float:
	if is_equal_approx(multiplier, 1.0): return old_value
	var new_val := old_value * multiplier
	if smoothen_values: new_val = roundf(new_val / factor) * factor
	return new_val

func _learn(hero: HeroData) -> void:
	hero.base_damage = \
		int(_new_value(
			hero.base_damage,
			damage_multiplier,
			DMG_SMOOTH_FACTOR
		))
	hero.attack_data.append(
		UnitAttackData.from_dict(attack_dict)
	)
