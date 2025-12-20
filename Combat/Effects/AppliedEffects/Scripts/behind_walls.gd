extends AppliedEffect

func _get_description() -> String:
	# Override this method in derived classes to define custom description
	return description % armor_increase

@export var armor_increase: int = 10

func check_trigger(a: Attack) -> void:
	if is_queued_for_deletion(): return

func read_params(params: Variant) -> void:
	if params is int:
		armor_increase = params

func _get_full_data(other_effect: AppliedEffect = null) -> Variant:
	if other_effect: return other_effect.armor_increase
	return armor_increase

func _apply_effect(params: Variant) -> void:
	read_params(params)
	target_unit.parameters.add_modifier(
		&"armor",
		self,
		func(a: int) -> int: return a + armor_increase
	)
