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

#region Combat
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
## This signal is diconnected from everything except [method CombatLogic.check_finished_animation] 
## at the end of each turn.
@warning_ignore("unused_signal") signal attack_animation_finished(unit: Unit)
## This signal is automatically disconnected from all receivers at the end of each turn.
## For persistent connections, use [signal attack_resolved] instead.
## @deprecated: use [method Object.call_deferred] instead
@warning_ignore("unused_signal") signal attack_resolved_trigger(attack: Attack)
## This signal maintains connections.
## Avoid using it for one-time effects that require manual cleanup.
@warning_ignore("unused_signal") signal attack_resolved(attack: Attack)
@warning_ignore("unused_signal") signal unit_died(unit: Unit)
@warning_ignore("unused_signal") signal unit_revived(unit: Unit)
@warning_ignore("unused_signal") signal unit_killed(unit: Unit, killer: Unit)
@warning_ignore("unused_signal") signal unit_moved(unit: Unit, old_pos: int)
@warning_ignore("unused_signal") signal unit_description_requested(unit: Unit)
@warning_ignore("unused_signal") signal effect_applied(effect: AppliedEffect)
@warning_ignore("unused_signal") signal effect_lifted(effect: AppliedEffect)
@warning_ignore("unused_signal") signal damage_taken(unit: Unit, dmg: int)
#endregion

#region Map
## Emitted before the actual movement occurs.
## The old position can be retrieved using [code]party.tile_position[/code].
## Movement can be canceled by setting [code]party.cancel_movement[/code] to [code]true[/code].
## [i](cancel_movement is automatically reset to false after signal processing)[/i]
signal party_move_started(party: MapParty, destination: Vector2i)
#endregion
