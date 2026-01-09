class_name HeroAbilitiesTree
extends Node

## Represents the level-up tree of a hero.
##
## On levelup, heroes receive exactly one player-selected ability.
## The abilities are intended to be structured as a tree but the system
## can behave in a variety of different ways (see [HeroAbility]).
## Heroes may also learn additional automatic abilities alongside the chosen one.
## These automatic abilities require no player investment and are granted freely.
## [br][br]
## This node should contain a list of all abilities for the hero.
## The intended design as follows: [br]
## 1. All children of this node and their children must be [HeroAbility] nodes.[br]
## 2. All children of this node (but not their children) are considered
##    available if hero's level matches the level requirement
##    (see [member HeroAbility.required_level]
##    and [member HeroAbility.available_once]).[br]
## 3. All abilities that have other abilities as children are considered 
##    prerequisites for those child abilities, meaning the children will
##    only be available after the parent is learned.[br]
## Thus, the node structure of this scene naturally becomes a level-up tree.[br]
## [br]
## Abilities with [member HeroAbility.optional] flag set to [code]false[/code]
## (such abilities are called [b]automatic[/b])
## will be automatically learned upon reaching the required level.
## Note that automatic abilities do not count as a choice.
## This means that the the hero can learn unlimited number of automatic abilities
## per level and the player will still be prompted to pick one optional ability. [br]
## Technically, the prerequisites structure still applies to automatic
## abilities as well, but it's not recommended to have 
## automatic abilities tied in the tree.
## The game will handle it just fine, but delivering such complex information
## to the player is difficult and most likely not worth it.


@onready var this_hero: HeroData = get_parent() if get_parent() is HeroData else null

## List of abilities that are [i]available[/i] (prerequisites learned).
## Includes abilities regardless of level requirements.
var available_list: Array[HeroAbility]

## Reads the children of this node to find available abilities and populates
## [member available_list].
func set_available_list() -> void:
	var list := get_children()
	available_list.clear()
	while list:
		var ability: HeroAbility = list.pop_front()
		if ability.learned:
			list.append_array(ability.get_children())
			continue
		available_list.append(ability)

func levelup() -> void:
	this_hero.level += 1
	var faction := this_hero.unit_owner
	var options := _get_available_optional_abilities()
	var option: HeroAbility = \
		await faction.api.choose_hero_ability(this_hero, options) \
		if faction else options.pick_random()
	if option:
		_learn_ability(option)
	for a in _get_available_automatic_abilities():
		_learn_ability(a)
	this_hero.current_hp = this_hero.max_hp

func _make_children_available(ability: HeroAbility) -> void:
	var temp: Array[HeroAbility] = []
	temp.assign(ability.get_children())
	available_list.append_array(temp)

func _learn_ability(ability: HeroAbility) -> void:
	ability.learn(this_hero)
	available_list.erase(ability)
	_make_children_available(ability)

func _check_level(ability: HeroAbility) -> bool:
	if ability.available_once:
		return this_hero.level == ability.required_level
	return this_hero.level >= ability.required_level

func _get_available_optional_abilities() -> Array[HeroAbility]:
	var res: Array[HeroAbility] = []
	for ability in available_list:
		if not ability.optional: continue
		if _check_level(ability): res.append(ability)
	return res

func _get_available_automatic_abilities() -> Array[HeroAbility]:
	var res: Array[HeroAbility] = []
	for ability in available_list:
		if ability.optional: continue
		if _check_level(ability): res.append(ability)
	return res

## Frees all direct and indirect children that are not a [HeroAbility] node
func clean_tree() -> void:
	var children := get_children()
	while children:
		var child: Node = children.pop_front()
		if child is HeroAbility:
			children.append_array(child.get_children())
			continue
		# Nodes free their children when freed
		child.free()

func _ready() -> void:
	clean_tree()
	set_available_list()
