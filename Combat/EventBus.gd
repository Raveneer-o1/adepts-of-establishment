extends Node

@warning_ignore("unused_signal") signal turn_ended(unit: Unit)
@warning_ignore("unused_signal") signal turn_started(unit: Unit)
@warning_ignore("unused_signal") signal round_ended()
@warning_ignore("unused_signal") signal round_started()
@warning_ignore("unused_signal") signal attack_booked(attack: Attack)
@warning_ignore("unused_signal") signal attack_reached(unit: Unit)
@warning_ignore("unused_signal") signal attack_animation_finished(unit: Unit)
@warning_ignore("unused_signal") signal unit_died(unit: Unit)

enum AttackType {
	Physical,
	Elemental,
	Mind,
	Life,
	None
}
