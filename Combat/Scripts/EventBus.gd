extends Node

var left_controller : Resource
var right_controller : Resource

var left_units: Array[String] = [
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
		"res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn",
]
var right_units: Array[String] = [
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		"res://Combat/Units/Derived units/Empire/e33 Hierophant.tscn",
		]

var packed_menu: PackedScene

@warning_ignore("unused_signal") signal spot_clicked(spot: UnitSpot)
@warning_ignore("unused_signal") signal wait_clicked()
@warning_ignore("unused_signal") signal defense_clicked()
@warning_ignore("unused_signal") signal start_attack_clicked()

@warning_ignore("unused_signal") signal turn_ended(unit: Unit)
@warning_ignore("unused_signal") signal turn_started(unit: Unit)
@warning_ignore("unused_signal") signal round_ended()
@warning_ignore("unused_signal") signal round_started()
@warning_ignore("unused_signal") signal attack_booked(attack: Attack)
@warning_ignore("unused_signal") signal attack_reached(unit: Unit)
@warning_ignore("unused_signal") signal attack_evaded(target: Unit, attack: Attack)
@warning_ignore("unused_signal") signal attack_missed(target: Unit, attack: Attack)
@warning_ignore("unused_signal") signal attack_animation_finished(unit: Unit)
@warning_ignore("unused_signal") signal unit_died(unit: Unit)
@warning_ignore("unused_signal") signal unit_description_requested(unit: Unit)
@warning_ignore("unused_signal") signal effect_applied(effect: AppliedEffect)
@warning_ignore("unused_signal") signal effect_lifted(effect: AppliedEffect)

enum AttackType {
	Physical,
	Elemental,
	Mind,
	Life,
	None
}
