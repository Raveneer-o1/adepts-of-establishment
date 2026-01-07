@abstract
class_name HeroAbility
extends Node

## An ability a hero can learn
##
## This class represents a node in the [HeroAbilitiesTree]. 

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

var learned := false

## Grants this ability to the [param hero].
## This method does not free the [HeroAbility] node
func learn(hero: HeroData) -> void:
	if learned: return
	_learn(hero)
	learned = true

@abstract func _learn(hero: HeroData) -> void
