extends AppliedEffect
class_name CureEffect

@export var display_text: String = "Cured"

## Called when the effect is applied to a unit.
func _apply_effect(params: Variant) -> void:
	for child in target_unit.parameters.get_children():
		if not child is AppliedEffect:
			continue
		
		# This souldn't be necessary but in case necative_effect flag
		# happens to mistakenly be set to true, we prevent self-lifting
		if child is CureEffect:
			continue
		
		if (child as AppliedEffect).negative_effect:
			(child as AppliedEffect).lift_effect()
			target_unit.system.display_text_near_unit(
				(child as AppliedEffect).target_unit,
				display_text, color_effect
			)
	
	# This effect removes itself after curing a unit
	queue_free()
