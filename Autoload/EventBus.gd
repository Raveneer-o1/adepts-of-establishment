extends Node

## This resource is instantiated as a child of the left [PlayerAPI] node.[br]
## [b]Note:[/b] The controller type is not validated and will be instantiated
## as provided.
var left_controller: Resource
## This resource is instantiated as a child of the right [PlayerAPI] node.[br]
## [b]Note:[/b] The controller type is not validated and will be instantiated
## as provided.
var right_controller : Resource

## List of units used to initialize the combat.
## The system does not consider the order of items in this list; only
## [member UnitData.party_position] is used for placement.
var left_units: Array[UnitData] = []
## List of units used to initialize the combat.
## The system does not consider the order of items in this list; only
## [member UnitData.party_position] is used for placement.
var right_units: Array[UnitData] = []

#var packed_menu: PackedScene

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
## Emitted when a single unit moves from [param old_pos] to a new position.
## The new position can be obtained via [member Unit.party_position].[br]
## [b]Note:[/b] this signal is [b]not[/b] emitted when two units swap places.
## Use [signal units_moved] for that.
signal unit_moved(unit: Unit, old_pos: int)
## Emitted when two units swap positions.
## Each unit's new position can be retrieved via [member Unit.party_position];
## their old positions are the other unit's new positions.
signal units_moved(first_unit: Unit, second_unit: Unit)
signal unit_description_requested(unit: Unit)
signal effect_applied(effect: AppliedEffect)
signal effect_lifted(effect: AppliedEffect)
signal damage_taken(unit: Unit, dmg: int, flags: Array[StringName])
signal unit_healed(unit: Unit, heal: int, flags: Array[StringName])
signal attack_shielded(attack: Attack, shielding_unit: Unit)

## Emitted when a unit‑related popup is displayed. The associated [Unit] object
## becomes active (unpausable) and marks itself as currently in use.
signal unit_question_started(data: UnitData)
## Emitted when the UI returns to its normal state after [signal unit_question_started].
signal unit_question_ended(data: UnitData)
#endregion

#region Map
## Emitted just before the party moves, allowing the move to be canceled.
## The old position can be retrieved using [code]party.tile_position[/code].
## To cancel the move, set [code]party.cancel_movement[/code] to [code]true[/code]
## or call [method PartyControl.abort_moving] (the [PartyControl] instance is
## available via [member MapParty.control]).
## Because of this, the signal does not guarantee that the party will actually move.
## For definitive movement, use [signal party_moved]. [br][br]
## [b]Note:[/b] cancel_movement is automatically reset to false after signal processing.
signal party_move_started(party: MapParty, destination: Vector2i)
## Emitted when the party has successfully moved to a new tile.
## The new tile can be retrieved with [member MapParty.tile_position].
## Unlike [signal party_move_started], this signal does not allow cancellation
## of the current move or future moves via [member MapParty.cancel_movement]
## or [method PartyControl.abort_moving].
signal party_moved(party: MapParty)
## Emitted on the first game day at the start of each faction’s turn,
## instead of [signal map_turn_started].
## Like [signal map_turn_started], this signal is emitted once per faction
## at the beginning of their turn.
signal first_map_turn_started(faction: MapFaction)
## Emitted at the start of each map turn, except for the very first day
## (use [signal first_map_turn_started] for that).
## Emitted once per faction, when their turn begins.
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
## Emitted when any window is closed with the same argument used to open it.
signal window_closed(info: Variant)

signal tile_claimed(tile: MapTileData, previous_owner: MapFaction)

signal unit_evolved(unit: UnitData, previous_form: StringName)

signal unit_hired(unit: UnitData)
signal party_hired(party: MapParty)
signal item_used(item: MapItem)

signal capital_changed(faction: MapFaction)

signal unit_transferred(unit: UnitData, previous_container: UnitsContainer)

signal item_equipped(item: MapItem, party: MapParty)

## Emitted when the player selects a dialogue option whose associated
## [member DialogueNode.dialogue_id] is defined.
signal dialogue_id_selected(id: StringName)

#endregion
