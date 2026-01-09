extends Control

## @experimental: for testing only, will be removed
@export var abilities_tree: HeroAbilitiesTree

func _ready() -> void:
	build_tree(abilities_tree)


@onready var layers_container: VBoxContainer = $LayersContainer

const LEVEL_LAYER = preload("uid://bs8ib1auh8e4")

func _find_max_level(tree: HeroAbilitiesTree) -> int:
	var res := 1
	var nodes := tree.get_children()
	while nodes:
		var node: HeroAbility = nodes.pop_front()
		if node.required_level > res: res = node.required_level
		nodes.append_array(node.get_children())
	return res

func _spawn_level_layers(tree: HeroAbilitiesTree) -> void:
	var max_level := _find_max_level(tree)
	for i in range(max_level):
		layers_container.add_child(LEVEL_LAYER.instantiate())

func _add_line(node1: Control, node2: Control) -> void:
	var line := Line2D.new()
	var rect1 := node1.get_rect()
	var rect2 := node2.get_rect()
	var pos1 := Vector2(
		(rect1.size.x) / 2.0,
		rect1.end.y
	) + node1.global_position
	var pos2 := Vector2(
		(rect2.size.x) / 2.0,
		rect2.position.y
	) + node2.global_position
	add_child(line)
	line.add_point(pos1)
	line.add_point(pos2)

func _handle_ability(
	mapping: Dictionary[HeroAbility, Control],
	prereq: HeroAbility
) -> void:
	for ability: HeroAbility in prereq.get_children():
		var index := ability.required_level - 1 if ability.required_level > 0 else 0
		var container: DynamicTree_LevelLayer = layers_container.get_child(index)
		var new_node: DynamicTree_Ability = container.add_ability(ability)
		new_node.init_ability(ability)
		_add_line.call_deferred(mapping[prereq], new_node)
		mapping[ability] = new_node

func _handle_layer(mapping: Dictionary[HeroAbility, Control]) -> void:
	for prereq: HeroAbility in mapping.keys():
		_handle_ability(mapping, prereq)
		mapping.erase(prereq)

## Creates all UI components necessary to represent provided [param tree]
func build_tree(tree: HeroAbilitiesTree) -> void:
	_spawn_level_layers(tree)
	var mapping: Dictionary[HeroAbility, Control] = {}
	for ability: HeroAbility in tree.get_children():
		var index := ability.required_level - 1 if ability.required_level > 0 else 0
		var container: DynamicTree_LevelLayer = layers_container.get_child(index)
		var new_node: DynamicTree_Ability = container.add_ability(ability)
		new_node.init_ability(ability)
		mapping[ability] = new_node
	
	while mapping: _handle_layer(mapping)
