extends HeroAbility

@export var attack_dict := {
	"attack_name" = "Silence all",
	"damage_multiplier" = 0.0,
	"damage_override" = true,
	"is_heal" = false,
	"type" = GlobalDefs.AttackType.None,
	"accuracy" = 1.0,
	"targets_needed" = 1,
	"initiative" = 0,
	"evadable" = true,
	"tags" = [],
	"target_validation" = "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres",
	"additional_targets" = "res://Combat/Units/Parameters/Additional targets/all_targets.tres",
	"damage_policy" = "",
	"applying_effects" = {
		"silence": 2
	},
	"alternative_actions" = [],
}

func _learn(hero: HeroData) -> void:
	for a in hero.attack_data:
		a.alternative_actions.append(
			UnitAttackData.from_dict(attack_dict)
		)
