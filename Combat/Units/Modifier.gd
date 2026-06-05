class_name ModifierStack

var stack: Array[Modifier]

func get_effective_value(value: Variant) -> Variant:
	if stack.is_empty():
		return value
	var last_value: Variant = value
	for modifier in stack:
		if modifier.active:
			last_value = modifier.influence.call(last_value)
	return last_value

func clean() -> void:
	var stack_copy := stack
	stack = []
	for modifier in stack_copy:
		if modifier.active:
			stack.append(modifier)

func add_modifier(effect: AppliedEffect, influence: Callable) -> void:
	var modifier: Modifier = Modifier.new(effect, influence)
	stack.append(modifier)

class Modifier:

	var effect: AppliedEffect

	var active: bool:
		get:
			return is_instance_valid(effect) and \
				#effect != null and \
				not effect.is_queued_for_deletion() and \
				not effect.silenced and \
				influence.is_valid()

	var influence: Callable
	
	func _init(eff: AppliedEffect, infl: Callable) -> void:
		effect = eff
		influence = infl
