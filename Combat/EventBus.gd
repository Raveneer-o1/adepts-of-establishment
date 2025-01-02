extends Node

signal turn_ended(unit: Unit)
signal turn_started(unit: Unit)
signal round_ended()
signal round_started()
signal attack_booked(attack: Attack)
signal attack_reached(unit: Unit)
signal attack_animation_finished(unit: Unit)
signal unit_died(unit: Unit)

enum AttackType {
	Physical,
	Elemental,
	Mind,
	Life,
	None
}
