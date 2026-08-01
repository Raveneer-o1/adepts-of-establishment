class_name CombatCamera
extends Camera2D

var tween: Tween

const SINGLE_STEP_DURATION: float = 0.05
const SINGLE_STEP_COST: float = 0.1
const SHIFT_SCALE: float = 5.0

func shake(force: float = 1.0) -> void:
	if not GameSettings.combat_camera_shake: return
	if force <= 0.0: return
	if tween: tween.kill()
	tween = create_tween()
	while force > 0.0:
		var target := Vector2(randf(), randf()) * force * SHIFT_SCALE
		force -= SINGLE_STEP_COST
		tween.tween_property(self, "position", target, SINGLE_STEP_DURATION)
	tween.tween_property(self, "position", Vector2.ZERO, SINGLE_STEP_DURATION)
