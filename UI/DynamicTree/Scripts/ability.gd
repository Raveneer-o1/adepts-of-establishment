class_name DynamicTree_Ability
extends MarginContainer

@onready var button: Button = $Ability

func init_ability(ability: HeroAbility) -> void:
	button.text = ability.ability_name
