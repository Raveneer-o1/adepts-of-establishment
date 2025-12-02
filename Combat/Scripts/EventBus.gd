extends Node

var left_controller : Resource
var right_controller : Resource

var left_units: Array[UnitData] = []
var right_units: Array[UnitData] = []

var packed_menu: PackedScene

#region Combat
signal battle_ended()

signal spot_clicked(spot: UnitSpot)
signal wait_clicked()
signal defense_clicked()
signal start_attack_clicked()

signal turn_ended(unit: Unit)
signal turn_started(unit: Unit)
signal round_ended()
signal round_started()
signal attack_booked(attack: Attack)
signal attack_reached(unit: Unit)
signal attack_evaded(target: Unit, attack: Attack)
signal attack_missed(target: Unit, attack: Attack)
## This signal is diconnected from everything except [method CombatLogic.check_finished_animation] 
## at the end of each turn.
signal attack_animation_finished(unit: Unit)
## This signal maintains connections.
## Avoid using it for one-time effects that require manual cleanup.
signal attack_resolved(attack: Attack)
signal unit_died(unit: Unit)
signal unit_revived(unit: Unit)
signal unit_killed(unit: Unit, killer: Unit)
signal unit_moved(unit: Unit, old_pos: int)
signal unit_description_requested(unit: Unit)
signal effect_applied(effect: AppliedEffect)
signal effect_lifted(effect: AppliedEffect)
signal damage_taken(unit: Unit, dmg: int)
#endregion

#region Map
## Emitted before the actual movement occurs.
## The old position can be retrieved using [code]party.tile_position[/code].
## Movement can be canceled by setting [code]party.cancel_movement[/code] to [code]true[/code].
## [i](cancel_movement is automatically reset to false after signal processing)[/i]
signal party_move_started(party: MapParty, destination: Vector2i)
#endregion
