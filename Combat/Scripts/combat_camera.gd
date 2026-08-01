class_name CombatCamera
extends Camera2D

var _tween: Tween

## Duration of a single camera movement step during a shake.
const SINGLE_STEP_DURATION: float = 0.05
## The amount by which the shake strength decreases with each step. [br]
## [b]Note:[/b] This value is only used when no duration is provided to [method shake].
const SINGLE_STEP_COST: float = 0.1
## Scaling factor for the camera displacement during a shake.
const SHIFT_SCALE: float = 5.0

## Shakes the camera with the given [param force] (strength of the shake).
## Easing is always linear, so stronger shakes last longer.
## If [param duration] is provided, the shake falloff is scaled to fit that time.
func shake(force: float = 1.0, duration: float = -1.0) -> void:
	if not GameSettings.combat_camera_shake: return
	if force <= 0.0: return
	if _tween: _tween.kill()
	_tween = create_tween()
	var single_step_cost: float = \
		SINGLE_STEP_COST if duration <= 0.0 \
		else force / (duration / SINGLE_STEP_DURATION)
	while force > 0.0:
		var target := Vector2(randf(), randf()) * force * SHIFT_SCALE
		force -= single_step_cost
		_tween.tween_property(self, "position", target, SINGLE_STEP_DURATION)
	_tween.tween_property(self, "position", Vector2.ZERO, SINGLE_STEP_DURATION)
