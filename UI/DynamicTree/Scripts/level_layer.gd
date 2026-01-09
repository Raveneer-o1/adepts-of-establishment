class_name DynamicTree_LevelLayer
extends Control

@onready var automatic_abilities_zone: HBoxContainer = $Main/AutomaticAbilitiesZone
@onready var optional_abilities_zone: HBoxContainer = $Main/OptionalAbilitiesZone

const ABILITY = preload("uid://canii4omifryt")

func add_ability(a: HeroAbility) -> Control:
	var res := ABILITY.instantiate()
	(
		optional_abilities_zone if a.optional else
		automatic_abilities_zone
	).add_child(res)
	return res
