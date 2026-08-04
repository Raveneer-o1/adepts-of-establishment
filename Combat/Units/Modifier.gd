class_name ModifierStack

var stack: Array[Modifier]

## Returns the value after applying all modifiers in the stack.
## The [param value] is the underlying value before any modifiers are applied.
func get_effective_value(value: Variant) -> Variant:
	if stack.is_empty():
		return value
	var last_value: Variant = value
	for modifier in stack:
		if modifier.active:
			last_value = modifier.influence.call(last_value)
	return last_value

## Removes all modifiers that reference invalid [AppliedEffect] objects.
func clean() -> void:
	var stack_copy := stack
	stack = []
	for modifier in stack_copy:
		if modifier.valid:
			stack.append(modifier)

## Adds a modifier associated with the given [param effect] to the stack.
## If the linked effect is invalidated (e.g., deleted or silenced), the modifier
## remains in the stack but no longer affects the result value.
## The modifier uses the provided [param influence] callback to compute the
## new value for this [ModifierStack]. The callback must accept a single argument
## (the current value) and return the modified value.
func add_modifier(effect: AppliedEffect, influence: Callable) -> void:
	var modifier: Modifier = Modifier.new(effect, influence)
	stack.append(modifier)

class Modifier:
	var effect: AppliedEffect
	var valid: bool:
		get:
			return is_instance_valid(effect) and \
				not effect.is_queued_for_deletion() and \
				influence.is_valid()
	var active: bool:
		get:
			return valid and \
				not effect.silenced
	var influence: Callable
	func _init(eff: AppliedEffect, infl: Callable) -> void:
		effect = eff
		influence = infl
