extends Node

var left_controller : Resource
var right_controller : Resource

var left_units: Array[UnitData] = []
var right_units: Array[UnitData] = []

var packed_menu: PackedScene

#region Combat
var is_battle_ready: bool:
	get: return is_battle_ready
	set(value):
		if value: battle_ready.emit()
		is_battle_ready = value

signal battle_ended()
signal battle_ready()

signal winner_determined(combat: CombatSystem)

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
signal damage_taken(unit: Unit, dmg: int, flags: Array[StringName])
signal unit_healed(unit: Unit, heal: int, flags: Array[StringName])
signal attack_shielded(attack: Attack, shielding_unit: Unit)

signal unit_question_started(data: UnitData)
signal unit_question_ended(data: UnitData)
#endregion

#region Map
## Emitted before the actual movement occurs.
## The old position can be retrieved using [code]party.tile_position[/code].
## Movement can be canceled by setting [code]party.cancel_movement[/code] to [code]true[/code].
## [i](cancel_movement is automatically reset to false after signal processing)[/i]
signal party_move_started(party: MapParty, destination: Vector2i)
signal map_turn_started(faction: MapFaction)
signal map_turn_ended(faction: MapFaction)

## Requests a popup to display information to the player.
## Popups typically show player-requested information (e.g., right-clicking an object).
## Distinct from [signal window_requested] - see that signal's documentation.[br][br]
## See also: [PopupBase]
signal popup_requested(object: Variant)
signal popup_closure_requested
## Requests a window to display information to the player.
## Windows show system-initiated information
## (e.g., resource deficiency notifications, item discovery alerts).
## Distinct from [signal popup_requested] - see that signal's documentation.[br][br]
## See also: [WindowBase]
signal window_requested(info: Variant)

signal tile_claimed(tile: MapTileData, previous_owner: MapFaction)

signal unit_evolved(unit: UnitData, previous_form: StringName)

signal unit_hired(unit: UnitData)
signal item_used(item: MapItem)

signal capital_changed(faction: MapFaction)
#endregion
