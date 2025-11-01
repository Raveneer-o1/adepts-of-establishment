extends AppliedEffect

@export var display_text: String = "Cured"

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	for child in target_unit.parameters.get_children():
		if child is not AppliedEffect:
			continue
		
		# This souldn't be necessary but in case negative_effect flag
		# happens to mistakenly be set to true, we prevent self-lifting
		if child == self:
			continue
		
		if (child as AppliedEffect).negative_effect:
			(child as AppliedEffect).lift_effect()
			target_unit.system.display_text_near_unit(
				(child as AppliedEffect).target_unit,
				display_text, color_effect
			)
	
	# This effect removes itself after curing a unit
	queue_free()
