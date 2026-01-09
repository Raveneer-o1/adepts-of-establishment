class_name DynamicTree_LevelLayer
extends Control

@onready var automatic_abilities_zone: HBoxContainer = $Main/AutomaticAbilitiesZone
@onready var optional_abilities_zone: HBoxContainer = $Main/OptionalAbilitiesZone

const ABILITY = preload("uid://canii4omifryt")
const BRANCH = preload("uid://cn28tcwqcj31d")

func init_branches(number: int) -> void:
	for i in range(number):
		optional_abilities_zone.add_child(BRANCH.instantiate())

func add_ability(a: HeroAbility, branch: int) -> Control:
	var res := ABILITY.instantiate()
	(
		optional_abilities_zone.get_child(branch - 1) if a.optional else
		automatic_abilities_zone
	).add_child(res)
	return res
