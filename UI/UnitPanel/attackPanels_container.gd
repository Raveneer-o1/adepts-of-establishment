class_name UI_UnitPanel_AttackPanel_Container
extends Control

const ATTACK_PANEL := preload("uid://cn26iuo3vxrgy")

## Matches the margins of the attack panel texture.
const MARGINS := Vector2(15.0, 15.0)
const ACTUAL_MARGINS := MARGINS * 2.0

## Offset applied to each stacked alternative attack.
const CHILDREN_STEP := Vector2(25.0, 10.0)

const NORMAL_Z_INDEX := 0
const VISIBLE_Z_INDEX := 1

var _current_visible_child := 0

## Populates the panel with attack data. The argument can be either a [UnitAttack]
## or a [UnitAttackData] object.
## [b]Note:[/b] The panel takes one frame to fully draw. Use [code]await[/code]
## if you need to wait for the drawing to complete.
func fill_data(data: Variant) -> void:
	_clear_panels()
	
	if data is UnitAttack:
		await _fill(data, _get_attack_children(data))
	elif data is UnitAttackData:
		await _fill(data, data.alternative_actions)
	else:
		push_error("Unexpected type: %s" % type_string(typeof(data)))

func _fill(main_attack: Variant, alternatives: Array) -> void:
	var max_size := Vector2.ZERO
	var alternative_count := 0

	# Create all alternative attacks first.
	for attack: Variant in alternatives:
		if attack is not UnitAttackData and attack is not UnitAttack:
			continue
		alternative_count += 1
		var panel := _create_panel(
			attack,
			CHILDREN_STEP * alternative_count,
			false
		)
	
	# Main attack is always on top.
	var main_panel := _create_panel(main_attack, Vector2.ZERO, true)
	# Wait until the panel computes its final size.
	await get_tree().process_frame
	
	max_size = _expand_bounds(max_size, main_panel)
	
	# Remove the stacking offset so every panel has the same internal size.
	for child in get_children():
		if child is UI_UnitPanel_AttackPanel:
			max_size = _expand_bounds(max_size, child)
	custom_minimum_size = max_size + ACTUAL_MARGINS
	
	var panel_size := max_size - CHILDREN_STEP * alternative_count * 2
	for child in get_children():
		if child is UI_UnitPanel_AttackPanel:
			max_size = _expand_bounds(max_size, child)
			child.custom_minimum_size = panel_size
			child.queue_redraw()


func _create_panel(data: Variant, position_: Vector2, interactive: bool) -> UI_UnitPanel_AttackPanel:
	var panel: UI_UnitPanel_AttackPanel = ATTACK_PANEL.instantiate()
	add_child(panel)
	panel.fill_data(data)
	panel.position = position_
	panel.mouse_behavior_recursive = \
		Control.MOUSE_BEHAVIOR_INHERITED if interactive \
		else Control.MOUSE_BEHAVIOR_DISABLED
	
	return panel

func _expand_bounds(current: Vector2, panel: Control) -> Vector2:
	var end := panel.position + panel.size
	return Vector2(
		maxf(current.x, end.x),
		maxf(current.y, end.y)
	)

func _clear_panels() -> void:
	for child in get_children():
		if child is UI_UnitPanel_AttackPanel:
			child.queue_free()
	_current_visible_child = 0

func _get_attack_children(attack: UnitAttack) -> Array:
	var result: Array = []
	for child in attack.get_children():
		if child is UnitAttack:
			result.append(child)
	return result

func switch_visible_child(next: bool) -> void:
	var count := get_child_count()
	if count <= 1:
		return
	
	_set_child_visible(_current_visible_child, false)
	if next:
		_current_visible_child = (_current_visible_child + 1) % count
	else:
		_current_visible_child = posmod(_current_visible_child - 1, count)
	
	_set_child_visible(_current_visible_child, true)

func _set_child_visible(index: int, _visible: bool) -> void:
	var child := get_child(index) as Control
	child.z_index = VISIBLE_Z_INDEX if _visible else NORMAL_Z_INDEX
	child.mouse_behavior_recursive = \
		Control.MOUSE_BEHAVIOR_INHERITED if _visible \
		else Control.MOUSE_BEHAVIOR_DISABLED

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if not event.is_pressed():
		return
	match event.button_index:
		MOUSE_BUTTON_WHEEL_UP:
			switch_visible_child(true)
		MOUSE_BUTTON_WHEEL_DOWN:
			switch_visible_child(false)
