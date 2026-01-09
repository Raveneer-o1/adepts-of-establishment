@abstract
class_name HeroAbility
extends Node

## An ability a hero can learn
##
## This class represents a node in the [HeroAbilitiesTree]. 

@export var ability_name: String
## Minimum hero level required to unlock this ability.
## Abilities do not appear as level-up options before reaching this level.
@export var required_level: int = 0
## When [code]true[/code], this ability can only be selected exactly at
## [member required_level].
@export var available_once: bool = false
## When [code]false[/code], the ability is automatically granted at
## [member required_level]. [br][br]
## Heroes may have unlimited automatic abilities but player can choose
## only one optional ability per level.
@export var optional: bool = true
## If [code]true[/code], this ability can be learned over and over again.
## Prevents [member learned] flag from setting.
@export var unlimited_learning: bool = false

var learned := false

## When [code]false[/code], prevents this ability from being learned.
## @experimental: not used, may be removed
var active := true

func can_be_learned(hero: HeroData) -> bool:
	if not active: return false
	if learned: return false
	if hero.level < required_level: return false
	if available_once and hero.level != required_level: return false
	var parent := get_parent()
	if parent is HeroAbility:
		if not parent.learned: return false
	return true

## Grants this ability to the [param hero].
func learn(hero: HeroData) -> void:
	if not can_be_learned(hero): return
	_learn(hero)
	if not unlimited_learning: learned = true

@abstract func _learn(hero: HeroData) -> void
