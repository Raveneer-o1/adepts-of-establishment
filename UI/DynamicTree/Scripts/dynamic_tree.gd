class_name UI_DynamicTree
extends Control

@export var test_tree: HeroAbilitiesTree
func _ready() -> void:
	if test_tree: build_tree(test_tree)

# UI Components
@onready var layers_container: VBoxContainer = $LayersContainer

var this_tree: HeroAbilitiesTree

const LEVEL_LAYER_SCENE = preload("uid://bs8ib1auh8e4")

signal ability_selected(ability: HeroAbility)

func _find_max_level(tree: HeroAbilitiesTree) -> int:
	var max_level := 1
	var nodes_to_process := tree.get_children()
	
	while nodes_to_process:
		var current_node: HeroAbility = nodes_to_process.pop_front()
		if current_node.required_level > max_level:
			max_level = current_node.required_level
		nodes_to_process.append_array(current_node.get_children())
	
	return max_level

func _spawn_level_layers(tree: HeroAbilitiesTree, branch_count: int) -> void:
	var max_level := _find_max_level(tree)
	for level_index in range(max_level):
		var new_layer: DynamicTree_LevelLayer = LEVEL_LAYER_SCENE.instantiate()
		layers_container.add_child(new_layer)
		new_layer.init_branches(branch_count)

func _connect_ability_nodes(source_node: Control, target_node: Control) -> void:
	await get_tree().process_frame
	# waiting for the nodes to be drawn,
	# otherwise global_position returns negative values
	
	var connection_line := Line2D.new()
	var source_rect := source_node.get_rect()
	var target_rect := target_node.get_rect()
	
	
	var start_position := Vector2(
		source_rect.size.x / 2.0,
		source_rect.end.y
	) \
	+ source_node.global_position \
	- global_position
	
	var end_position := Vector2(
		target_rect.size.x / 2.0,
		target_rect.position.y
	) \
	+ target_node.global_position \
	- global_position
	
	add_child(connection_line)
	connection_line.add_point(start_position)
	connection_line.add_point(end_position)

func _process_ability_children(
	ability_to_ui_map: Dictionary[HeroAbility, Control],
	branch_assignment_map: Dictionary[HeroAbility, int],
	parent_ability: HeroAbility
) -> void:
	for child_ability: HeroAbility in parent_ability.get_children():
		var level_index := child_ability.required_level - 1 \
			if child_ability.required_level > 0 else 0
		var level_container: DynamicTree_LevelLayer = \
			layers_container.get_child(level_index)
		var assigned_branch := branch_assignment_map[child_ability]
		
		var ability_node: DynamicTree_Ability = \
			level_container.add_ability(child_ability, assigned_branch)
		ability_node.init_ability(child_ability)
		
		_connect_ability_nodes(
			ability_to_ui_map[parent_ability],
			ability_node
		)
		ability_to_ui_map[child_ability] = ability_node

func _process_current_layer(
	ability_to_ui_map: Dictionary[HeroAbility, Control],
	branch_assignment_map: Dictionary[HeroAbility, int]
) -> void:
	# AFAIK, duplicate() is not necessary here but it doesn't hurt to have it
	var abilities_in_current_layer := ability_to_ui_map.keys().duplicate()
	
	for parent_ability: HeroAbility in abilities_in_current_layer:
		_process_ability_children(
			ability_to_ui_map,
			branch_assignment_map,
			parent_ability
		)
		ability_to_ui_map.erase(parent_ability)

func _count_branches(tree: HeroAbilitiesTree) -> int:
	var branch_count := 0
	var main_branch_counted := false
	
	for child_ability: HeroAbility in tree.get_children():
		if not child_ability.optional:
			continue
		
		# Handle abilities with no children (leaf nodes)
		if child_ability.get_child_count() == 0:
			if main_branch_counted:
				continue
			main_branch_counted = true
			branch_count += 1
			continue
		
		# Each ability with children gets its own branch
		branch_count += 1
	
	return branch_count

func _create_branch_assignment_map(tree: HeroAbilitiesTree) \
-> Dictionary[HeroAbility, int]:
	var assignment_map: Dictionary[HeroAbility, int] = {}
	var next_branch_id := 2  # Branch IDs: 0=auto, 1=main, 2+=additional branches
	
	for child_ability: HeroAbility in tree.get_children():
		if not child_ability.optional:
			assignment_map[child_ability] = 0  # Automatic ability
			continue
		
		if child_ability.get_child_count() == 0:
			assignment_map[child_ability] = 1  # Main branch
			continue
		
		# Assign current branch to this ability and all its descendants
		assignment_map[child_ability] = next_branch_id
		
		# Recursively assign same branch to all children
		var descendant_nodes := child_ability.get_children()
		while descendant_nodes:
			var descendant: HeroAbility = descendant_nodes.pop_front()
			assignment_map[descendant] = next_branch_id
			descendant_nodes.append_array(descendant.get_children())
		
		next_branch_id += 1
	
	return assignment_map

## Creates all UI components necessary to represent provided [param tree]
func build_tree(tree: HeroAbilitiesTree) -> void:
	if not tree:
		push_error("Null tree")
		return
	if this_tree == tree:
		update()
		return
	
	this_tree = tree
	var ability_to_ui_map: Dictionary[HeroAbility, Control] = {}
	var branch_assignment_map := _create_branch_assignment_map(tree)
	var total_branches := _count_branches(tree)
	
	_spawn_level_layers(tree, total_branches)
	
	# Create initial ability nodes (first level)
	for root_ability: HeroAbility in tree.get_children():
		var level_index := root_ability.required_level - 1 \
			if root_ability.required_level > 0 else 0
		var level_container: DynamicTree_LevelLayer = \
			layers_container.get_child(level_index)
		var assigned_branch := branch_assignment_map[root_ability]
		
		var ability_node: DynamicTree_Ability = \
			level_container.add_ability(root_ability, assigned_branch)
		ability_node.init_ability(root_ability)
		ability_to_ui_map[root_ability] = ability_node
	
	# Process remaining levels
	while ability_to_ui_map:
		_process_current_layer(ability_to_ui_map, branch_assignment_map)

## Updates the values in the UI (e.g., deactivates learned abilities)
func update() -> void:
	for layer: DynamicTree_LevelLayer in layers_container.get_children():
		layer.update()
