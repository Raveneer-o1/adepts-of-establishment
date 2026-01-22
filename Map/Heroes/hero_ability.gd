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
## Placing this ability inside the tree will block all abilities after it as it
## can never be considered learned and thus can never be satisfied as a
## prerequisite. [br]
## [b]Note:[/b] You can set the [member learned] flag manually to create custom 
## behavior. For example, by setting this flag to [code]true[/code] and manually
## setting [member learned] after three learning iterations you can create 
## multi-stage abilities.
@export var unlimited_learning: bool = false

@export_multiline var description: String

## When [code]true[/code], marks the ability as learned, making subsequent
## abilities in the tree available while disabling this one for selection. [br]
## [b]Note:[/b] [member unlimited_learning] only prevents automatic flag setting
## upon learning - if you assign this flag manually, ability will be considered
## learned regardless of [member unlimited_learning] value.
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
